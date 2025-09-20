# Shared nix-darwin settings applied to all macOS hosts
{ ... }:
{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "@admin" "root" ];
  };

  # Touch ID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  # macOS system defaults
  system.defaults = {
    dock = {
      autohide = true;
      show-recents = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      ShowStatusBar = true;
    };
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
    };
  };

  # nix-darwin requires this to be set
  system.stateVersion = 5;
}
