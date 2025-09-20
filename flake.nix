# jcekstrom flake.nix
# Unified flake managing:
#   nixosConfigurations  — ora (Framework 13 AMD), lima-vm (colima/lima dev VM)
#   darwinConfigurations — RESML-CT2334DN6X (macOS work laptop)
#   homeConfigurations   — jce (standalone), ssm-user (AWS SSM)
{
  description = "jcekstrom system configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim-config = {
      url = "github:jcekstrom/nixvim-config/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    omarchy-nix = {
      url = "github:jcekstrom/omarchy-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-lima = {
      url = "github:nixos-lima/nixos-lima";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nix-darwin,
      nixos-hardware,
      nixvim-config,
      nixos-generators,
      ...
    }:
    let
      # Helper: build unstable pkgs for a given system
      unstableFor = system: import nixpkgs-unstable { inherit system; };

      # extraSpecialArgs shared by all home-manager configurations
      hmSpecialArgs =
        system:
        let
          unstable = unstableFor system;
        in
        {
          inherit inputs system nixvim-config unstable;
        };
    in
    {
      # ------------------------------------------------------------------ #
      # NixOS configurations
      # ------------------------------------------------------------------ #
      nixosConfigurations = {

        # Framework 13-inch 7040 AMD — primary Linux workstation
        ora = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.config.allowUnfree = true; }
            ./hosts/ora/default.nix
            {
              # Pass unstable + nixvim-config into home-manager for the jce user
              home-manager.extraSpecialArgs =
                (hmSpecialArgs "x86_64-linux")
                // {
                  userinfo = {
                    username = "jce";
                    homedir = "/home/jce";
                  };
                };
            }
          ];
        };

        # lima/colima development VM — full jce profile in a NixOS VM
        lima-vm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.config.allowUnfree = true; }
            ./hosts/lima-vm/default.nix
            {
              home-manager.extraSpecialArgs =
                (hmSpecialArgs "x86_64-linux")
                // {
                  userinfo = {
                    username = "jce";
                    homedir = "/home/jce";
                  };
                };
            }
          ];
        };
      };

      # ------------------------------------------------------------------ #
      # nix-darwin configurations
      # ------------------------------------------------------------------ #
      darwinConfigurations = {

        # macOS work laptop
        "RESML-CT2334DN6X" = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.config.allowUnfree = true; }
            ./hosts/work-mac/default.nix
            {
              home-manager.extraSpecialArgs =
                (hmSpecialArgs "aarch64-darwin")
                // {
                  userinfo = {
                    username = "jekstr928@cable.comcast.com";
                    homedir = "/Users/jekstr928@cable.comcast.com";
                  };
                };
            }
          ];
        };
      };

      # ------------------------------------------------------------------ #
      # Standalone home-manager configurations
      # (for contexts without a full NixOS/darwin system config)
      # ------------------------------------------------------------------ #
      homeConfigurations = {

        "jce" =
          let
            system = "x86_64-linux";
            pkgs = import nixpkgs { inherit system; };
            userinfo = {
              username = "jce";
              homedir = "/home/jce";
            };
          in
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [ ./home ];
            extraSpecialArgs = (hmSpecialArgs system) // { inherit userinfo; };
          };

        "ssm-user" =
          let
            system = "x86_64-linux";
            pkgs = import nixpkgs { inherit system; };
            unstable = unstableFor system;
            userinfo = {
              username = "ssm-user";
              homedir = "/home/ssm-user";
            };
          in
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [ ./home ];
            extraSpecialArgs = {
              inherit inputs system userinfo nixvim-config unstable;
            };
          };
      };

      # ------------------------------------------------------------------ #
      # Package outputs
      # ------------------------------------------------------------------ #
      packages.x86_64-linux.lima-vm-img = nixos-generators.nixosGenerate {
        pkgs = import nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; };
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/lima-vm/default.nix
          {
            home-manager.extraSpecialArgs =
              (hmSpecialArgs "x86_64-linux")
              // {
                userinfo = {
                  username = "jce";
                  homedir = "/home/jce";
                };
              };
          }
        ];
        format = "qcow-efi";
      };
    };
}
