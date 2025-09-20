# ora — Framework 13-inch 7040 AMD
# Host-specific NixOS system configuration.
# Shared settings (nix, locale, allowUnfree) live in modules/nixos/common.nix.
# Desktop environments live in modules/nixos/desktops/.
{ pkgs, ... }:
{
  # Cross-platform builds (e.g. nix build for aarch64-linux)
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Track the latest Linux kernel for best Framework hardware support
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.grub = {
    enable = true;
    devices = [ "nodev" ];
    efiSupport = true;
    useOSProber = true;
    memtest86.enable = true;
    default = "saved";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "ora";
    networkmanager = {
      enable = true;
      plugins = [ pkgs.networkmanager-l2tp ];
    };
  };

  # Display manager: ly (shows both Plasma and Hyprland sessions)
  services.displayManager.sddm.enable = false;
  services.displayManager.ly = {
    enable = true;
    settings = {
      load = true;
      save = true;
    };
  };

  # X11 keymap (used by some Wayland compositors for fallback)
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;
  services.avahi.enable = true;
  services.resolved.enable = true;
  services.flatpak.enable = true;

  services.pipewire = {
    enable = true;
    raopOpenFirewall = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    extraConfig.pipewire = {
      "10-airplay" = {
        "context.modules" = [
          { name = "libpipewire-module-raop-discover"; }
        ];
      };
    };
  };
  services.pulseaudio.enable = false;

  services.fprintd.enable = true;
  services.fwupd.enable = true;
  services.hardware.bolt.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  security.rtkit.enable = true;
  security.polkit.enable = true;

  # CIFS / NFS
  services.gvfs.enable = true;
  services.rpcbind.enable = true;
  systemd.automounts = [
    {
      wantedBy = [ "multi-user.target" ];
      automountConfig.TimeoutIdleSec = "600";
      where = "/mnt/synology";
    }
  ];

  xdg.portal = {
    xdgOpenUsePortal = true;
    enable = true;
  };

  users.users.jce = {
    isNormalUser = true;
    uid = 1026;
    description = "Joey Ekstrom";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" ];
  };

  programs = {
    htop.enable = true;
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };
    nix-ld.enable = true;
    virt-manager.enable = true;
  };

  virtualisation = {
    docker = {
      enable = true;
      daemon.settings.data-root = "/home/docker-data";
    };
    libvirtd.enable = true;
    waydroid.enable = false;
    spiceUSBRedirection.enable = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    bitwarden-desktop
    bitwarden-cli
    cifs-utils
    nfs-utils
    element-desktop
    lan-mouse
    os-prober
    prismlauncher
    slack
    stdenv.cc.cc.lib
    thunderbird
    udftools
    wayland-utils
    wget
    wl-clipboard
    claude-code

    # L2TP VPN
    networkmanager-l2tp
    strongswan
    xl2tpd
  ];

  services.openssh.enable = true;
  services.tailscale.enable = true;

  networking.firewall = {
    allowedTCPPorts = [ 8080 24800 ];
    allowedTCPPortRanges = [ { from = 8000; to = 8999; } ];
    allowedUDPPorts = [ 24800 ];
  };

  system.stateVersion = "24.11";
}
