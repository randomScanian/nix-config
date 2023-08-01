{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hardware.url = "github:nixos/nixos-hardware";

    theming.url = "github:randomScanian/theming";
    theming.flake = false;
    xmonad-config.url = github:randomScanian/xmonad-config;
    xmonad-config.flake = false;
    doom-emacs-config.url = github:randomScanian/doom-emacs-config ;
    doom-emacs-config.flake = false;
    awesomewm-config.url = github:randomScanian/awesomewm-config;
    awesomewm-config.flake = false;
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      hmModulesDir = ./modules/hm;
      nixosModulesDir = ./modules/nixos;
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      
      mkHost =
        { hostname
        , system ? "x86_64-linux"
        , stateVersion ? "23.05"
        , allowUnfree ? false
        }:
        nixpkgs.lib.nixosSystem {
          pkgs = inputs.nixpkgs.legacyPackages.${system};
          modules = [
            "${nixosModulesDir}/sharedConfig.nix"
            "${nixosModulesDir}/default.nix"
            ./hosts/${hostname}
            {
              networking.hostName = hostname;
              nixpkgs.hostPlatform.system = system;
              nixpkgs.config.allowUnfree = allowUnfree;
              system.stateVersion = stateVersion;
            }
          ];
          
          specialArgs = { inherit inputs outputs hmModulesDir; };
        };
      mkHome =
        { hostName
        , userName
        , stateVersion
        , system
        , allowUnfree
        }: home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.${system};
          modules = [
            "${hmModulesDir}/sharedConfig.nix"
            "${hmModulesDir}/default.nix"
            ./hm/${userName}/${hostName}
              {
                nixpkgs.config.allowUnfree = allowUnfree;
                nixpkgs.config.allowUnfreePredicate = (_: allowUnfree);
                home = {
                  username = "${userName}";
                  homeDirectory = "/home/${userName}";
                  stateVersion = stateVersion;
                };
              }
          ];
          extraSpecialArgs = {inherit inputs outputs; };
        };
    in
      rec {
        packages = forAllSystems (system:
          let pkgs = nixpkgs.legacyPackages.${system};
          in import ./pkgs { inherit pkgs; }
        );
        
        devShells = forAllSystems (system:
          let pkgs = nixpkgs.legacyPackages.${system};
          in import ./shell.nix { inherit pkgs; }
        );
        
        overlays = import ./overlays { inherit inputs; };
        
        nixosConfigurations = {
          Abydos = mkHost {
            hostname = "Abydos";
            system = "x86_64-linux";
            stateVersion = "23.05";
            allowUnfree = true;
          };
          Chulak = mkHost {
            hostname = "Chulak";
            system = "x86_64-linux";
            stateVersion = "23.05";
            allowUnfree = true;
          };
        };

        homeConfigurations = {
          #This system does not exist yet...
          #It currently serves as a demo for i would setup standalone home-manager in the future.
          Demo = mkHome {
            hostName = "Demo";
            userName = "randomscanian";
            system = "x86_64-linux";
            stateVersion = "23.05";
            allowUnfree = true;
          };
        };
      };
}
