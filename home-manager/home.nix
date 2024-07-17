# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  system,
  ...
}: let
  nixvimcfg = import ./nixvim;
  nvim = inputs.nixvim.legacyPackages.${pkgs.system}.makeNixvimWithModule {
    inherit pkgs;
    module = nixvimcfg;
  };
in {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nixvim
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  # TODO: Set your username
  home = {
    username = "jce";
    homeDirectory = "/home/jce";

    # Add stuff for your user as you see fit:
    # programs.neovim.enable = true;
    packages = with pkgs; [
      awscli2
      bitwarden-cli
      curl
      chromium
      fq
      gitprompt-rs
      gnumake
      inetutils
      jira-cli-go
      joplin
      nvim
      pstree
      python3
      silver-searcher
      tig
      tmux
      wget
    ];
  };

  programs = {
    home-manager = {
      enable = true;
    };

    bash = {
      enable = true;
      historyControl = ["erasedups"];
      historyIgnore = ["ls"];
      historySize = 1500;

      profileExtra = ''
        export PATH=$HOME/bin:$PATH
      '';

      initExtra = ''
        RED="\[\033[0;31m\]"
        YELLOW="\[\033[0;33m\]"
        GREEN="\[\033[01;32m\]"
        BLUE="\[\033[01;34m\]"
        GREY="\[\033[01;232m\]"
        CLEAR="\[\033[00m\]"
        PS1="$YELLOW\u@\h$CLEAR:$GREEN\w $YELLOW\$(gitprompt-rs)$CLEAR\$ "

        export TZ=America/Los_Angeles
      '';

      shellAliases = {
        vim = "nvim";
        vi = "nvim";
        vimdiff = "nvim -d";
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
    fzf = {
      enable = true;
      enableBashIntegration = true;
    };
    htop.enable = true;
    jq.enable = true;

    gh = {
      enable = true;

      settings = {
        git_protocol = "ssh";
        prompt = "enabled";
      };
    };

    gh-dash = {
      enable = true;
    };

    git = {
      enable = true;
      delta.enable = true;
      userName = "Joey Ekstrom";
      userEmail = "joey@ekstech.net";
      aliases = {
        co = "checkout";
      };
    };

    tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      keyMode = "vi";
      mouse = false;
      prefix = "C-a";
      terminal = "screen-256color";
      extraConfig = ''
        bind-key a send-prefix
        bind-key C-a last-window

        # disable sound bell
        set -g bell-action none
        # disable visual bell
        set -g visual-bell off

        set -g status-bg colour110
      '';
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
