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
    # Busybox recovery entries — all use the initrd's built-in busybox ash shell.
    # No extra packages needed; busybox is always present in the NixOS initrd.
    extraEntries = ''
      submenu "Recovery (busybox initrd shell)" {
        # Shell on fail: boots normally but drops to busybox if anything fails
        menuentry "NixOS — shell on boot failure" {
          search --set=drive1 --fs-uuid 41f42a72-13ec-4eed-8ccf-abb88953094a
          linux ($drive1)/nix/var/nix/profiles/system/kernel \
            init=/nix/var/nix/profiles/system/init \
            boot.shell_on_fail \
            $kernelparams
          initrd ($drive1)/nix/var/nix/profiles/system/initrd
        }
        # Immediate shell: drops to busybox at the very start of stage 1
        menuentry "NixOS — debug shell (immediate, stage 1)" {
          search --set=drive1 --fs-uuid 41f42a72-13ec-4eed-8ccf-abb88953094a
          linux ($drive1)/nix/var/nix/profiles/system/kernel \
            init=/nix/var/nix/profiles/system/init \
            boot.debug1 \
            $kernelparams
          initrd ($drive1)/nix/var/nix/profiles/system/initrd
        }
        # Shell after devices: useful for diagnosing disk/crypto/module issues
        menuentry "NixOS — debug shell (after devices)" {
          search --set=drive1 --fs-uuid 41f42a72-13ec-4eed-8ccf-abb88953094a
          linux ($drive1)/nix/var/nix/profiles/system/kernel \
            init=/nix/var/nix/profiles/system/init \
            boot.debug1devices \
            $kernelparams
          initrd ($drive1)/nix/var/nix/profiles/system/initrd
        }
        # Shell after mounts: filesystem is mounted, good for fsck/data recovery
        menuentry "NixOS — debug shell (after mounts)" {
          search --set=drive1 --fs-uuid 41f42a72-13ec-4eed-8ccf-abb88953094a
          linux ($drive1)/nix/var/nix/profiles/system/kernel \
            init=/nix/var/nix/profiles/system/init \
            boot.debug1mounts \
            $kernelparams
          initrd ($drive1)/nix/var/nix/profiles/system/initrd
        }
      }
    '';
  };
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "ora";
    networkmanager = {
      enable = true;
      plugins = [ pkgs.networkmanager-l2tp ];
    };
  };

  # Display manager: greetd with tuigreet (configured in modules/nixos/desktops/omarchy.nix)
  services.displayManager.sddm.enable = false;

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
    enable = true;
    xdgOpenUsePortal = true;
    # KDE Plasma 6 provides portal backends directly
    # These are automatically available when Plasma is enabled above
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
    less  # ensure GNU less takes priority over busybox less in root nix profile
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

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-mono
    maple-mono.NF
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
