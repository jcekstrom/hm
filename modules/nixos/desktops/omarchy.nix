# Hyprland desktop via omarchy-nix
# Both this and plasma.nix are imported so both sessions are available at the
# display manager.  Pick the session you want at login — no rebuild required.
{ inputs, ... }:
{
  imports = [ inputs.omarchy-nix.nixosModules.default ];

  omarchy = {
    full_name = "Joey Ekstrom";
    email_address = "joey@ekstech.net";
    theme = "tokyo-night";
    # monitors = [];  # add monitor strings when needed, e.g. "DP-1,2560x1440,0x0,1"
    # scale = 2;      # HiDPI scale factor (default 2)
  };
}
