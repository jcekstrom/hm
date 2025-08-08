{ inputs, userinfo, pkgs, system, ... }:
{
  imports = [
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userinfo.username;
  home.homeDirectory = userinfo.homedir;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    pkgs.awscli2
    #pkgs.bitwarden-cli
    pkgs.curl
    pkgs.fq
    pkgs.gitprompt-rs
    pkgs.gnumake
    pkgs.inetutils
    pkgs.jira-cli-go
    pkgs.joplin
    pkgs.jujutsu
    pkgs.pandoc
    pkgs.pstree
    pkgs.python312
    pkgs.python312Packages.pip
    pkgs.python312Packages.ipython
    pkgs.python312Packages.oauth2
    pkgs.ripgrep
    pkgs.silver-searcher
    pkgs.tig
    pkgs.tmux
    pkgs.w3m
    pkgs.wget
		inputs.ghostty.packages.${system}.default
    inputs.nixvim-config.packages.${system}.default
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jekstr928@cable.comcast.com/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;

    bash = {
      enable = true;
      historyControl = ["erasedups"];
      historyIgnore = ["ls"];
      historySize = 1500;

      profileExtra = ''
        export PATH=$HOME/bin:$HOME/.local/bin:$PATH
      '';

      bashrcExtra =''
bw_unlock () {
  if ! bw unlock --check; then
    export BW_SESSION=`bw unlock --raw`  
    tmux set-environment -g BW_SESSION $BW_SESSION
  fi
}

function prompt_command() {
  if [[ -n "''${TMUX}" ]]; then
    eval "$(tmux show-environment -s)"
    if [[ -n "''${BW_SESSION}" ]]; then
      export `tmux show-environment -g BW_SESSION`
    fi
  fi
}

PROMPT_COMMAND=prompt_command

      '';
      initExtra = ''
        RED="\[\033[0;31m\]"
        YELLOW="\[\033[0;33m\]"
        GREEN="\[\033[01;32m\]"
        BLUE="\[\033[01;34m\]"
        GREY="\[\033[01;232m\]"
        CLEAR="\[\033[00m\]"
        PS1="$YELLOW\h$CLEAR:$GREEN\w $YELLOW\$(gitprompt-rs)$CLEAR\$ "

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

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };

    bat.enable = true;
    eza.enable = true;
    fzf = {
      enable = true;
      #enableBashIntegration = true;
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
      #delta.enable = true;
      userName = "Joey Ekstrom";
      userEmail = "joey@ekstech.net";
      aliases = {
        co = "checkout";
      };
    };

    #nixvim = {
    #  config = import ./nixvim/config/default.nix { };
    #};

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

    gpg = {
      enable = true;
      
    };
    zsh = {
      enable = true;
      enableVteIntegration = true;
      dotDir = ".config/zsh";
      envExtra = ''
      '';
      history = {
        # append = true;
        expireDuplicatesFirst = true;
        ignorePatterns = [ "rm *" "ps *" "ls *" ];
      };
      initExtra = ''
      '';
      initExtraFirst = ''
      '';
      loginExtra = ''
      '';
      prezto = {
        enable = true;
        editor = {
         keymap = "vi";
        }; 
        
      };
      #profileExtra = ''
#eval "$(/opt/homebrew/bin/brew shellenv)"     	 
#      '';
    };
  };
    
  services = {
    #ssh-agent.enable = true;
    gpg-agent = {
      enable = false;
      enableBashIntegration = true;
      enableSshSupport = true;
      enableScDaemon = false;
    };
  };
}
