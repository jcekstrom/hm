{ inputs, userinfo, pkgs, system, unstable, ... }:
{
  nixpkgs.config.allowUnfree = true;

  imports = [
	  ./accounts.nix
    ./ssh.nix
  ];

	home = {
		# Home Manager needs a bit of information about you and the paths it should
		# manage.
		username = userinfo.username;
		homeDirectory = userinfo.homedir;

		# This value determines the Home Manager release that your configuration is
		# compatible with. This helps avoid breakage when a new Home Manager release
		# introduces backwards incompatible changes.
		#
		# You should not change this value, even if you update Home Manager. If you do
		# want to update the value, then make sure to first check the Home Manager
		# release notes.
		stateVersion = "24.11"; # Please read the comment before changing.

		# The packages option allows you to install Nix packages into your
		# environment.
		packages = [
			# # It is sometimes useful to fine-tune packages, for example, by applying
			# # overrides. You can do that directly here, just don't forget the
			# # parentheses. Maybe you want to install Nerd Fonts with a limited number of
			# # fonts?
			# (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

			# # You can also create simple shell scripts directly inside your
			# # configuration. For example, this adds a command 'my-hello' to your
			# # environment:
			# (pkgs.writeShellScriptBin "my-hello" ''
			#   echo "Hello, ${config.username}!"
			# '')
			pkgs.awscli2
			pkgs.maple-mono.NF
			#pkgs.bitwarden-cli
			pkgs.curl
			pkgs.deskflow
			pkgs.fq
			pkgs.gitprompt-rs
			pkgs.gnumake
			pkgs.inetutils
			pkgs.jira-cli-go
			pkgs.joplin
			unstable.jujutsu
			unstable.opencode
			pkgs.pandoc
			pkgs.pstree
			pkgs.python314
			pkgs.python313Packages.pip
			pkgs.python313Packages.ipython
      #pkgs.python314Packages.oauth2
			pkgs.ripgrep
			pkgs.silver-searcher
			pkgs.tig
			pkgs.tmux
			pkgs.w3m
			pkgs.wget
			inputs.nixvim-config.packages.${system}.default
      pkgs.claude-code
		];

		# Home Manager is pretty good at managing dotfiles. The primary way to manage
		# plain files is through 'file'.
		file = {
			# # Building this configuration will create a copy of 'dotfiles/screenrc' in
			# # the Nix store. Activating the configuration will then make '~/.screenrc' a
			# # symlink to the Nix store copy.
			# ".screenrc".source = dotfiles/screenrc;

			# # You can also set the file content immediately.
			# ".gradle/gradle.properties".text = ''
			#   org.gradle.console=verbose
			#   org.gradle.daemon.idletimeout=3600000
			# '';
      ".npmrc" = {
        enable = true;
        text = ''
          registry=https://registry.npmjs.org/
          prefix=${userinfo.homedir}/.cache/npm/global
        '';
      };
      ".config/ghostty/custom.css" = {
        text = ''
          headerbar {
            height: 8px;
            padding: 0;
            margin: 0;
          }

          headerbar button {
            margin: 0;
            border: 1px solid black;
          }

          headerbar button image {
            padding: 0;
            margin: 0;
          }

          tabbox {
            font-family: monospace;
            margin: 0;
            padding: 0;
          }

          tabbox tab {
            margin: 0;
            padding: 0;
          }

          tabbox tab label {
            font-size: 14px;
            margin: 0;
            padding: 0;
          }

          tab {
            max-width: 140px;
          }

          notebook > header.top {
            margin-left: 0;
            margin-right: auto;
            justify-content: flex-start;
          }

          notebook > header.top > tabs > tab {
            max-width: 150px;
            min-width: 50px;
          }
        '';
      };
    };

		# Home Manager can also manage your environment variables through
		# 'sessionVariables'. These will be explicitly sourced when using a
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
		sessionVariables = {
			EDITOR = "nvim";
			SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/rbw/ssh-agent-socket";
		};

		sessionPath = [
			"${userinfo.homedir}/bin"
			"${userinfo.homedir}/.cache/npm/global/bin"
			"${userinfo.homedir}/.local/bin"
		];

	};

  # Let Home Manager install and manage itself.
	programs = {
		home-manager.enable = true;

    ghostty = {
      enable = true;
      enableBashIntegration = true;
      installBatSyntax = true;
      settings = {
        async-backend = "epoll";
        clipboard-paste-protection = false;
        confirm-close-surface = false;
        cursor-style = "block";
        cursor-style-blink = false;
        font-family = "Maple Mono NF";
        font-size = 9;
        font-style = "Regular";
        gtk-toolbar-style = "flat";
        mouse-scroll-multiplier = 0.95;
        resize-overlay = "never";
        shell-integration-features = "ssh-terminfo";
        window-padding-x = 2;
        window-padding-y = 2;
        keybind = [
          "shift+insert=paste_from_clipboard"
          "control+insert=copy_to_clipboard"
          "super+c=copy_to_clipboard"
          "super+v=paste_from_clipboard"
          "ctrl+k=reset"
          "shift+enter=text:\\x1b\\r"
        ];
      };
      themes.omarchy = {
        background = "#1a1b26";
        foreground = "#a9b1d6";
        selection-background = "#2f3549";
        selection-foreground = "#1a1b26";
        palette = [
          "0=#1a1b26"  "1=#c0caf5"  "2=#9ece6a"  "3=#0db9d7"
          "4=#2ac3de"  "5=#bb9af7"  "6=#b4f9f8"  "7=#a9b1d6"
          "8=#444b6a"  "9=#c0caf5"  "10=#9ece6a" "11=#0db9d7"
          "12=#2ac3de" "13=#bb9af7" "14=#b4f9f8" "15=#d5d6db"
          "16=#a9b1d6" "17=#f7768e" "18=#16161e" "19=#2f3549"
          "20=#787c99" "21=#cbccd1"
        ];
      };
    };
		#thunderbird = {
		#	enable = true;
		#};
		#offlineimap = {
		#		enable = true;
		#};
		#mujmap = {
		#	enable = true;
		#};
		#mu = {
		#	enable = true;
		#};
		#meli = {
		#	enable = true;
		#};
		lieer = {
			enable = true;
		};
		himalaya = {
			enable = true;
		};
		#getmail = {
		#	enable = true;
		#};
		#astroid = {
		#	enable = true;
		#};
		#alot = {
		#	enable = true;
		#};
		#imapnotify = {
		#	enable = true;
		#};
		mbsync.enable = true;
    msmtp.enable = true;
    notmuch = {
      enable = true;
      #hooks = {
      #preNew = "mbsync --all";
      #};
    };
    aerc = {
      enable = true;
      #extraBinds = {
      #  messages = {
      #    "*" = ":check-mail";
      #  };
      #};
      extraConfig = {
        general = {
          unsafe-accounts-conf = true;
          check-mail-cmd = "mbsync \"$AERC_ACCOUNT\" &";
        };
        compose = {
          editor = "nvim";
        };
        filters = {
          "text/plain" = "colorize";
          "text/calendar" = "calendar";
          "message/delivery-status" = "colorize";
          "message/rfc822" = "colorize";
          #"text/html" = "w3m -dump";
          "text/html" = "pandoc -f html -t plain | colorize";
          #"text/html" = "browsh --startup-url $AERC_FILENAME";
          #text/html=html | colorize
          #"text/*" = "bat -fP --file-name=\"$AERC_FILENAME\"";
        };
        hooks = {
          mail-deleted = "mbsync \"$AERC_ACCOUNT:$AERC_FOLDER\" &";
          mail-added = "mbsync \"$AERC_ACCOUNT:$AERC_FOLDER\" &";
        };
      };
    };
    alot = {
      enable = true;
    };
    neomutt = {
      enable = true;
      sidebar = {
        enable = true;
      };
      sort = "reverse-threads";
      vimKeys = true;
    };


    bash = {
      enable = true;
      historyControl = ["erasedups"];
      historyIgnore = ["ls"];
      historySize = 1500;

      profileExtra = ''
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
      gitCredentialHelper.enable = true;
      settings = {
        git_protocol = "ssh";
        prompt = "enabled";
      };
    };

    rbw = {
      enable = true;
      package = unstable.rbw;
      settings = {
        email = "joey@ekstrom.org";
        lock_timeout = 3600;
        pinentry = pkgs.pinentry-qt;
      };
    };

    gh-dash = {
      enable = true;
    };

    git = {
      enable = true;
      #delta.enable = true;
      settings = {
        user.name = "Joey Ekstrom";
        user.email = "joey@ekstech.net";
        alias.co = "checkout";
      };
    };

    starship = {
      enable = true;
      settings = {
        # Show relative path from home (~/…) or absolute path if outside home
        directory = {
          home_symbol = "~";
          truncation_length = 3;
          truncation_symbol = "…/";
          format = "[$path]($style)[$read_only]($read_only_style) ";
        };

        # Disable git modules when in a jj repo; they still show elsewhere
        git_branch.disabled = false;
        git_status.disabled = false;

        # Custom jujutsu module — shown instead of git when in a .jj repo
        custom.jujutsu = {
          description = "Jujutsu change id and bookmark";
          # Shows shortest unique change ID, plus bookmark name if one exists
          command = "jj log --no-graph --ignore-working-copy -r @ --template 'change_id.shortest() ++ if(bookmarks, \" \" ++ bookmarks.join(\", \"), \"\")' 2>/dev/null";
          when = "test -d .jj";
          style = "bold blue";
          symbol = "jj ";
          format = "on [$symbol$output]($style) ";
        };
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
      dotDir = "${userinfo.homedir}/.config/zsh";
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
    ssh-agent.enable = false;  # replaced by rbw SSH agent
		#gpg-agent = {
		#  enable = false;
		#  enableBashIntegration = true;
		#  enableSshSupport = true;
		#  enableScDaemon = false;
		#};
  };
}
