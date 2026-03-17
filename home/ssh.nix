{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "jce.github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/ssh-jcekstrom.pub";
        identitiesOnly = true;
        forwardAgent = false;
      };

      "xc.github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/ssh-xumo-ghec.pub";
        identitiesOnly = true;
        forwardAgent = false;
      };

      "xumo.github.com github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/ssh-xumo-ed25519.pub";
        identitiesOnly = true;
        forwardAgent = false;
      };

      "xumo jekxumo" = {
        hostname = "RESML-CT2334DN6X.local";
        user = "jekstr928@cable.comcast.com";
        identityFile = "~/.ssh/ssh-xumo-ed25519.pub";
        forwardAgent = true;
      };

      "homeassistant" = {
        hostname = "homeassistant.local";
        user = "root";
        forwardAgent = true;
      };

      "dev" = {
        hostname = "dev.local";
        user = "jce";
        identityFile = "~/.ssh/ssh-xumo.pub";
        forwardAgent = true;
        dynamicForwards = [{ port = 60777; }];
      };

      "xumo-dev" = {
        hostname = "54.226.42.189";
        user = "admin";
        identityFile = "~/.ssh/ssh-xumo-dev.pub";
        forwardAgent = true;
      };

      "xumo-aws" = {
        hostname = "54.84.220.240";
        user = "jce";
        identityFile = "~/.ssh/ssh-xumo.pub";
        forwardAgent = true;
        localForwards = [{ bind.port = 8888; host.address = "127.0.0.1"; host.port = 8888; }];
      };

      "centos" = {
        hostname = "35.245.91.209";
        user = "jce";
        identityFile = "~/.ssh/ssh-xumo.pub";
        forwardAgent = true;
      };

      "storage storage.local synology synology.local" = {
        user = "jce";
        identityFile = "~/.ssh/ssh-personal.pub";
        forwardAgent = true;
      };

      "x1vm" = {
        user = "jce";
        identityFile = "~/.ssh/ssh-personal.pub";
        forwardAgent = true;
      };

      "ekstech" = {
        hostname = "git.ekstech.net";
        port = 922;
        user = "jce";
        identityFile = "~/.ssh/ssh-xumo.pub";
        forwardAgent = true;
        dynamicForwards = [{ port = 60777; }];
      };

      "hahaw" = {
        hostname = "hahaw.tailf53a98.ts.net";
        user = "jce";
        identityFile = "~/.ssh/ssh-xumo.pub";
        forwardAgent = true;
      };

      "honu honu.ekstech.net" = {
        hostname = "ha.haw.eksfam.org";
        port = 60777;
        user = "jce";
        identityFile = "~/.ssh/ssh-xumo.pub";
        forwardAgent = true;
      };

      "ha.local" = {
        user = "root";
        identityFile = "~/.ssh/ssh-personal.pub";
        forwardAgent = true;
      };

      "ha-ekstech-net" = {
        user = "root";
        identityFile = "~/.ssh/ssh-personal.pub";
        forwardAgent = true;
      };

      "captions" = {
        hostname = "18.144.49.139";
        user = "ubuntu";
        identityFile = "~/.ssh/ssh-captions.pub";
        forwardAgent = true;
      };

      "*" = {
        forwardAgent = true;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        compression = false;
        addKeysToAgent = "yes";
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
    };
  };

  # Public keys only — private keys live in Bitwarden, served by rbw SSH agent.
  # These are not secret and are committed to the repo for portability.
  home.file = {
    ".ssh/ssh-personal.pub" = {
      text = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEA0loh9QOQWw+W6Wd8JunoL0oLkhN4ld74lIt/hI+L7TYLccBQnU8oVG2QVwP0w2Z7T3SJkNfko86k6i2TKwGEaGyXGIoH94XEXQDPkLz9tv8CsKxBcnRTFD0A4fvr5DLcMp4I3OSm1mpQafdk8nIaD0rAEcZRoIqSV28ssuYute27CaPGq4S8VplwhHVr8bdDPugAqZ7h6hGzIVu1a4DSo40ZLsLSXl5H/ktqEohoBsF4MOyq4p/8RERlhMUOMBLR8F9+vIqHNxlD8fz8Pp4MMoAu/g+tey/GxDW+T8GDI62ICPag3e9Pw+XD1dyRhS5kFmKVEqO2uhz+4K2w2tzDQw== rsa-key-20180308";
    };
    ".ssh/ssh-jcekstrom.pub" = {
      text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBxqEzbfyPllMyPEmTqS0HwhL6ir8f599kgdXlF6ianz jce@ora";
    };
    ".ssh/ssh-xumo.pub" = {
      text = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCxw8qTx+Z0JD79OZRKaUw04m2YhjdXesDotArv+jDrp1gc5/guB5HCkJMNBI3CWcLMpG4fBCokAzv4qNVwr7ZDhyYPXOnAlWflFw3sWVgFGTL83W70tu6gyGB0QnHkBgQsKODCzI/K8qDeBEwysa6Wb0s0GLfi85H+pmj24uC9kaVrMoxhjU8oYjvFRXkPEYvlhIdmLM3JLdPD3IpoxVzruj4cJee3eYNWNccJNYJky6exeZHId+BNGcl9+qdEBBY7Z4DQZp7rUZBSmrv5lMrXs2LMpyanjOyCKXgcC+kpKdd3Pp8z8C0QCrm/7nuYpMPMeFIZuESmbgPlP1R5NDK5 jce@X1";
    };
    ".ssh/ssh-xumo-ed25519.pub" = {
      text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMWQmx8q0nKgKdexINtzoXWktd0XBVIZ+UJYKNfmaqkS jekstr328@cable.comcast.com@RESML-9553086";
    };
    ".ssh/ssh-xumo-ghec.pub" = {
      text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA1u/fupDD419FlZWoCjT/avWmE30wruAvdc3oywhPF1 jekstr928@cable.comcast.com@RESML-CT2334DN6X";
    };
    ".ssh/ssh-xumo-dev.pub" = {
      text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA3+6b2JwqkrUnAXCZKO5o9fLuFneuftojWaRFjcNitW";
    };
    ".ssh/ssh-captions.pub" = {
      text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOT128uRuLUbaeTcDH3OUbhMkhdFJ8zhiSwlzoyKqQXg";
    };
  };
}
