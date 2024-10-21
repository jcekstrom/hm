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
}:# let
  #nixvimcfg = import ./nixvim;
  #nvim = inputs.nixvim.legacyPackages.${pkgs.system}.makeNixvimWithModule {
  #  inherit pkgs;
  #  module = nixvimcfg;
  #};
#in
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    #inputs.nixvim.homeManagerModules.nixvim
		#./accounts
    ./nixvim
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
      browsh
      curl
      chromium
      firefox
      fq
      gitprompt-rs
      gnumake
      inetutils
      jira-cli-go
      joplin
      pandoc
      pstree
			python311
			python311Packages.pip
			python311Packages.ipython
			python311Packages.oauth2
      silver-searcher
      tig
      tmux
      w3m
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
    #himalaya.enable = true;
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
    mbsync.enable = true;
    msmtp.enable = true;
    notmuch = {
      enable = true;
      #hooks = {
      #preNew = "mbsync --all";
      #};
    };
    gpg = {
      enable = true;
      
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
  };

  accounts = {
    calendar = {
    };
    email = {
      accounts = {
        ekstrom = {
          address = "joey@ekstrom.org";
          #gpg = {
          #  key = "F9119EC8FCC56192B5CF53A0BF4F64254BD8C8B5";
          #  signByDefault = true;
          #};
          imap.host = "mail.ekstrom.org";
          aerc = {
            enable = true;
            extraAccounts = {
              #source = "maildir://~/Maildir/ekstrom";
              #check-mail-cmd = "mbsync ekstrom";
              multi-file-strategy = "act-dir";
              check-mail = "5m";
              check-mail-cmd = "mbsync ekstrom && notmuch new";
              check-mail-timeout = "90s";
              maildir-account-path = "ekstrom";
              maildir-store = "~/Maildir";
              source = "notmuch://~/Maildir/";
            };
          };
          himalaya.enable = true;
          mbsync = {
            enable = true;
            create = "maildir";
						expunge = "both";
          };
          msmtp.enable = true;
          neomutt = {
            enable = true;
          };
          notmuch.enable = true;
          primary = true;
          realName = "Joey Ekstrom";
          signature = {
            text = ''
              -Joey
            '';
            showSignature = "append";
          };
          passwordCommand = "bw get password af0b0524-c372-424b-b7f3-b0b800fc5174";
          smtp = {
            host = "mail.ekstrom.org";
          };
          userName = "joey@ekstrom.org";
        };
        ekstech = {
          address = "joey@ekstech.net";
          #gpg = {
          #  key = "F9119EC8FCC56192B5CF53A0BF4F64254BD8C8B5";
          #  signByDefault = true;
          #};
          imap.host = "moose.mxrouting.net";
          aerc = {
            enable = true;
            extraAccounts = {
              #source = "maildir://~/Maildir/ekstech";
              #check-mail-cmd = "mbsync ekstech";
              source = "notmuch://~/Maildir/";
              maildir-store = "~/Maildir";
              maildir-account-path = "ekstech";
							multi-file-strategy = "act-dir";
              check-mail-cmd = "mbsync ekstech && notmuch new";
              check-mail-timeout = "90s";
              check-mail = "5m";
            };
          };
          mbsync = {
            enable = true;
						expunge = "both";
            create = "maildir";
          };
          msmtp.enable = true;
          neomutt = {
            enable = true;
          };
          himalaya.enable = true;
          notmuch.enable = true;
          realName = "Joey Ekstrom";
          signature = {
            text = ''
              -Joey Ekstrom
            '';
            showSignature = "append";
          };
          passwordCommand = "bw get password 77f82336-9c67-47a4-b7d3-ae2d01307340";
          smtp = {
            host = "moose.mxrouting.net";
          };
          userName = "joey@ekstech.net";
        };
        rcmtb = {
          address = "joey@rcmtb.org";
          #gpg = {
          #  key = "F9119EC8FCC56192B5CF53A0BF4F64254BD8C8B5";
          #  signByDefault = true;
          #};
          imap.host = "moose.mxrouting.net";
          aerc = {
            enable = true;
            extraAccounts = {
              #source = "maildir://~/Maildir/rcmtb";
              #check-mail-cmd = "mbsync rcmtb";
              source = "notmuch://~/Maildir/";
              maildir-store = "~/Maildir";
              maildir-account-path = "rcmtb";
							multi-file-strategy = "act-dir";
              check-mail-cmd = "mbsync rcmtb && notmuch new";
              check-mail-timeout = "90s";
              check-mail = "5m";
            };
          };
          mbsync = {
            enable = true;
						expunge = "both";
            create = "maildir";
          };
          msmtp.enable = true;
          neomutt = {
            enable = true;
          };
          himalaya.enable = true;
          notmuch.enable = true;
          realName = "Joey Ekstrom";
          signature = {
            text = ''
              -Joey
            '';
            showSignature = "append";
          };
          passwordCommand = "bw get password 58096753-9c17-44c8-92cd-aeb500036755";
          smtp = {
            host = "moose.mxrouting.net";
          };
          userName = "joey@rockcreekmtb.org";
        };
        sablerock = {
          address = "sablerock@ekstech.net";
          #gpg = {
          #  key = "F9119EC8FCC56192B5CF53A0BF4F64254BD8C8B5";
          #  signByDefault = true;
          #};
          imap.host = "moose.mxrouting.net";
          aerc = {
            enable = true;
            extraAccounts = {
              #source = "maildir://~/Maildir/sablerock";
              #check-mail-cmd = "mbsync sablerock";
              source = "notmuch://~/Maildir";
              maildir-store = "~/Maildir";
              maildir-account-path = "sablerock";
              check-mail-cmd = "mbsync sablerock && notmuch new";
              check-mail-timeout = "90s";
              check-mail = "5m";
							multi-file-strategy = "act-dir";
            };
          };
          mbsync = {
            enable = true;
						expunge = "both";
            create = "maildir";
          };
          msmtp.enable = true;
          neomutt = {
            enable = true;
          };
          himalaya.enable = true;
          notmuch = {
            enable = true;
            neomutt.enable = true;
          };
          realName = "Joey Ekstrom";
          signature = {
            text = ''
              -Joey
            '';
            showSignature = "append";
          };
          passwordCommand = "bw get password 8b527369-ef83-4ef0-b5bc-afcd0136f1ac";
          smtp = {
            host = "moose.mxrouting.net";
          };
          userName = "sablerock@ekstech.net";
        };
#        gmail = {
#          address = "jcekstrom@gmail.com";
#          #gpg = {
#          #  key = "F9119EC8FCC56192B5CF53A0BF4F64254BD8C8B5";
#          #  signByDefault = true;
#          #};
#          imap.host = "moose.mxrouting.net";
#          aerc = {
#            enable = true;
#
#            extraAccounts = {
#							# source-cred-cmd =
#              #check-mail-cmd = "mbsync sablerock";
#							source = "imaps+xoauth2://jcekstrom@imap.gmail.com:993?";
#              outgoing = "smtps+xoauth2://jcekstrom@smtp.gmail.com:465?";
#              check-mail-timeout = "90s";
#              check-mail = "5m";
#							user-gmail-ext = true;
#            };
#					  imapOauth2Params = {
#						imapAuth = "xoauth2";
#							token_endpoint = "https://oauth2.googleapis.com/token";
#							client_id = "17312651470-3irvr3pr93tj0rdt7lj23mvmmslb7330.apps.googleusercontent.com";
#							client_secret = "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";
#							client_scope = "https://mail.google.com";
#						};
#						smtpAuth = "xoauth2";
#						smtpOauth2Params = {
#							token_endpoint = "https://oauth2.googleapis.com/token";
#							client_id = "17312651470-3irvr3pr93tj0rdt7lj23mvmmslb7330.apps.googleusercontent.com";
#							client_secret = "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";
#							client_scope = "https://mail.google.com";
#						};
#          };
#          realName = "Joey Ekstrom";
#          signature = {
#            text = ''
#              -Joey
#            '';
#            showSignature = "append";
#          };
#          passwordCommand = "bw get password a8dd606a-b3b3-4ee6-bd70-ace9000fe59d";
#          smtp = {
#            host = "moose.mxrouting.net";
#          };
#          userName = "jcekstrom@gmail.com";
#        };
      };
    };
  };

  services = {
    ssh-agent.enable = true;
    gpg-agent = {
      enable = false;
      enableBashIntegration = true;
      enableSshSupport = true;
      enableScDaemon = false;
    };
    mbsync = {
      enable = true;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
