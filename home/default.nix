{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      bitwarden-cli
      curl
      bat
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
    
    bash = {
      enable = true;
      historyControl = [ "erasedups" ];
      historyIgnore = [ "ls" ];
      historySize = 1500;

      profileExtra = ''
        '';
      
      initExtra = ''
        '';

      shellAliases = {
      };

      shellOptions = [
        "histappend"
        "checkwinsize"
        "extglob"
        "globstar"
        "checkjobs"
      ];

    };

    bat.enable = true;
    eza.enable = true;
    htop.enable = true;
    jq.enable = true;

    gh = {
      enable = true;
      settings = {
        git_protocol = "https";
      };
    };

    git = {
      enable = true;
      delta.enable = true;
      userName = mkDefault "Joey Ekstrom";
      userEmail = mkDefault "joey@ekstech.net";
      aliases = {
        co = "checkout";
      };
    };
      
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
