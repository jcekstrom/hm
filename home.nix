{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      hello
    ];

    username = "jce";
    homeDirectory = "/home/jce";

    # Don't ever change this after the first build.
    stateVersion = "23.11";
  };
}
