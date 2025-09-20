# work-mac — RESML-CT2334DN6X (aarch64-darwin)
{ inputs, pkgs, ... }:
{
  imports = [
    ../../modules/darwin/common.nix
    inputs.home-manager.darwinModules.home-manager
  ];

  networking.hostName = "RESML-CT2334DN6X";

  # Homebrew — placeholder for GUI/cask apps that aren't in nixpkgs for darwin
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };
    casks = [
      # Add macOS-specific casks here, e.g.:
      # "zoom"
      # "1password"
    ];
    brews = [
      # Add homebrew formulas here if needed
    ];
  };

  # System packages available to all users on this machine
  environment.systemPackages = with pkgs; [
    curl
    git
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
      system = "aarch64-darwin";
      userinfo = {
        username = "jekstr928@cable.comcast.com";
        homedir = "/Users/jekstr928@cable.comcast.com";
      };
    };
    users."jekstr928@cable.comcast.com" = import ../../home;
  };
}
