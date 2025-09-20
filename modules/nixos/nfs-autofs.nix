# Dynamic on-demand NFS mounting via autofs
#
# Mounts NFS exports from any host under /nfs/<hostname>/.
# Accessing /nfs/<hostname>/<export> triggers an on-demand NFS mount.
# Mounts are automatically unmounted after idle timeout.
#
# Usage:
#   cd /nfs/synology/volume1/homes    → mounts synology:/volume1/homes
#   cd /nfs/somehost/export/path      → mounts somehost:/export/path
#
# Hostname resolution: bare names (e.g. "synology") are tried first;
# if showmount fails, ".local" is appended for mDNS hosts.
{ pkgs, ... }:
let
  autoNfsScript = pkgs.writeShellScript "auto.nfs" ''
    SERVER="$1"

    # Try bare hostname first; fall back to .local for mDNS-only hosts
    # (e.g. "synology" fails DNS but "synology.local" resolves via avahi)
    if ! ${pkgs.nfs-utils}/bin/showmount -e --no-headers "$SERVER" &>/dev/null; then
      SERVER="$SERVER.local"
    fi

    EXPORTS=$(${pkgs.nfs-utils}/bin/showmount -e --no-headers "$SERVER" 2>/dev/null \
      | ${pkgs.gawk}/bin/awk '{print $1}')

    if [ -z "$EXPORTS" ]; then
      exit 1
    fi

    # Emit autofs multi-mount format:
    #   first token  = mount options
    #   each subsequent "\n\t/subpath\tserver:/export" = one sub-mount
    printf -- "-fstype=nfs,rw,soft,intr,nfsvers=4"
    while IFS= read -r export; do
      printf " \\\n\t%s\t%s:%s" "$export" "$SERVER" "$export"
    done <<< "$EXPORTS"
    echo
  '';
in
{
  services.autofs = {
    enable   = true;
    timeout  = 60;
    autoMaster = ''
      /nfs  program:${autoNfsScript}
    '';
  };

  # showmount requires rpcbind
  services.rpcbind.enable = true;
}
