{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      bat
      bitwarden-cli
      htop
      awscli2
      chromium
      fq
      gnumake
      inetutils
      jq
      pstree
      python3
      silver-searcher
      tmux
      wget
    ];

    username = "jce";
    homeDirectory = "/home/jce";

    # Don't ever change this after the first build.
    stateVersion = "23.11";
  };

  programs = {
    home-manager = {
      enable = true;
    };

    git.enable = true;
      
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      plugins = with pkgs.vimPlugins; [
        vim-fugitive
        vim-nix
        awesome-vim-colorschemes
        ack-vim
      ];

      extraConfig = lib.fileContents ./init.vim;
    };
  };

}
