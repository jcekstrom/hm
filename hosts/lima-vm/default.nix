# lima-vm — NixOS image for use with lima/colima on macOS
# Contains the full jce home-manager profile inside a lightweight NixOS VM.
#
# Build the qcow2 image:
#   nix build .#lima-vm-img --out-link result/nixos.qcow2
#
# Start the VM:
#   limactl start hosts/lima-vm/nixos.yaml --name nixos
#
# Rebuild inside the VM from the host:
#   limactl shell nixos -- sudo nixos-rebuild switch --flake .#lima-vm
{ inputs, pkgs, lib, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    inputs.nixos-lima.nixosModules.lima   # lima-init + lima-guestagent
    ../../modules/nixos/common.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  # GRUB EFI with efiInstallAsRemovable — Lima VMs have no persistent EFI
  # variable store, so we must not write to EFI vars at install time.
  boot.loader.grub = {
    device = "nodev";
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;

  # Disk layout matching nixos-lima's qcow-efi format:
  #   vda1 = ESP (/boot, vfat)
  #   vda2 = root (/,  ext4, labeled "nixos")
  fileSystems."/boot" = {
    device = lib.mkForce "/dev/vda1";
    fsType = "vfat";
  };
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
    fsType = "ext4";
    options = [ "noatime" "nodiratime" "discard" ];
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "console=tty0" ];

  networking.hostName = "lima-vm";

  # SSH — Lima connects via SSH
  services.openssh.enable = true;

  # lima-init creates the user from cidata userdata at first boot and adds
  # them to the wheel group.  wheelNeedsPassword = false lets sudo work
  # without a password in the VM (standard Lima expectation).
  security.sudo.wheelNeedsPassword = false;

  # Declare the jce account so NixOS/home-manager have a target user.
  # SSH key injection is handled by lima-init at first boot.
  users.users.jce = {
    isNormalUser = true;
    uid = 1026;
    description = "Joey Ekstrom";
    extraGroups = [ "wheel" "docker" ];
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };
  programs.nix-ld.enable = true;

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    curl
    git
    wget
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.jce = import ../../home;
  };

  system.stateVersion = "24.11";
}
