{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
        { hostname ? "CHANGEME"
        , system ? "x86_64-linux"
        , stateVersion ? "23.05"
        , homeStateVersion ? "23.05"
        , allowUnfree ? true
        , isNvidia ? false
        }:
        nixpkgs.lib.nixosSystem {
          modules = [
            inputs.home-manager.nixosModules.home-manager
            "${nixosModulesDir}"
            ./hosts/${hostname}/default.nix
          ];
          
          specialArgs = { inherit inputs outputs hmModulesDir allowUnfree isNvidia system hostname stateVersion homeStateVersion; };
        };
      mkHome =
        { hostName ? "CHANGEME"
        , userName ? "CHANGEME"
        , stateVersion ? "23.05"
        , system ? "x86_64-linux"
        , allowUnfree ? true
        }: home-manager.lib.homeManagerConfiguration {
          modules = with inputs; [
            home-manager.nixosModules.home-manager
            "${hmModulesDir}"
            ./hm/${hostName}/${userName}
          ];
          extraSpecialArgs = {inherit inputs outputs userName allowUnfree; };
        };
    in
      rec {
        packages = forAllSystems (system:
          let pkgs = nixpkgs.legacyPackages.${system};
          in import ./pkgs { inherit pkgs; }
        );
        
        #devShells = forAllSystems (system:
        #  let pkgs = nixpkgs.legacyPackages.${system};
        #  in import ./shell.nix { inherit pkgs; }
        #);
        
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
            isNvidia = false;
          };
        };

        homeConfigurations = {
          #This system does not exist yet...
          #It currently serves as a demo for i would setup standalone home-manager in the future.
          Demo = mkHome {
            hostName = "Demo"; # the hostname of the system, needed for module import
            userName = "randomscanian"; #the name of the user
            system = "x86_64-linux"; # the value the system variable should be set to. usefull if running on mac or ARM based machine, probably wont need but nice to have.
            stateVersion = "23.05"; # check nixos wiki for stateversion variable.
            allowUnfree = true; # Whether or not to allow installation of unFree/proprietary software
          };
        };
      };
}
