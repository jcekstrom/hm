# jcekstrom flake.nix
{
  description = "Home Manager configuration of Joey Ekstrom";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim-config = {
      url = "github:pete3n/nixvim-flake/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
		
		#ghostty = {
		#	url = "github:ghostty-org/ghostty";
		#};
  };

  outputs = inputs@{ nixpkgs, nixpkgs-unstable, home-manager, nixvim-config, ... }:
  {
      homeConfigurations = {
        "jekstr928@cable.comcast.com" = let
					system = "aarch64-darwin";
      		pkgs = import nixpkgs { inherit system; };
					userinfo = {
						username = "jekstr928@cable.comcast.com";
						homedir = "/Users/jekstr928@cable.comcast.com/";
					};
        in home-manager.lib.homeManagerConfiguration {
					inherit pkgs;
          modules = [
            ./home
          ];
          extraSpecialArgs = {
          # Pass inputs to your home-manager module
            inherit inputs system userinfo nixvim-config;
          };
         };
        "jce" = let
      		system = "x86_64-linux";
      		pkgs = import nixpkgs { inherit system; };
					userinfo = {
						username = "jce";
						homedir = "/home/jce";
					};
        in home-manager.lib.homeManagerConfiguration {
					inherit pkgs;
          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [
            ./home
          ];
          extraSpecialArgs = {
          # Pass inputs to your home-manager module
            inherit inputs system userinfo nixvim-config;
          };
      };
        "ssm-user" = let
      		system = "x86_64-linux";
      		pkgs = import nixpkgs { inherit system; };
					userinfo = {
						username = "ssm-user";
						homedir = "/home/ssm-user";
					};
        in home-manager.lib.homeManagerConfiguration {
					inherit pkgs;
          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [
            ./home
          ];
          extraSpecialArgs = {
          # Pass inputs to your home-manager module
            inherit inputs system userinfo nixvim-config;
          };
      };
    };
	};
}
