# ora — top-level NixOS host configuration
{ inputs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd

    ./hardware-configuration.nix
    ./system.nix

    ../../modules/nixos/common.nix
    ../../modules/nixos/desktops/plasma.nix
    ../../modules/nixos/nfs-autofs.nix

    inputs.home-manager.nixosModules.home-manager
  ];

  # home-manager config is in flake.nix
}
