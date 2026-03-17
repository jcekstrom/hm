# work-mac — RESML-CT2334DN6X (aarch64-darwin)
{ inputs, pkgs, ... }:
{
  imports = [
    ../../modules/darwin/common.nix
    inputs.home-manager.darwinModules.home-manager
  ];

  networking.hostName = "RESML-CT2334DN6X";

  # linux-builder — lightweight aarch64-linux VM used by Nix to build Linux
  # derivations natively on Apple Silicon (no cross-compilation overhead).
  # Required for: nix build .#packages.aarch64-linux.lima-vm-img
  # After enabling, run: darwin-rebuild switch, then the builder starts automatically.
  nix.linux-builder = {
    enable = true;
    ephemeral = true;   # fresh VM state on each darwin-rebuild switch
    maxJobs = 4;
  };

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
