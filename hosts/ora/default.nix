# ora — top-level NixOS host configuration
{ inputs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd

    ./hardware-configuration.nix
    ./system.nix

    ../../modules/nixos/common.nix
    ../../modules/nixos/desktops/plasma.nix
    ../../modules/nixos/desktops/omarchy.nix
    ../../modules/nixos/nfs-autofs.nix

    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
      system = "x86_64-linux";
      userinfo = {
        username = "jce";
        homedir = "/home/jce";
      };
    };
    users.jce = import ../../home;
  };
}
