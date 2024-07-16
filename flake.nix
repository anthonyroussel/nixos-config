{
  description = "NixOS system-wide configuration";

  inputs = {
    nixpkgs = {
      url = "nixpkgs/nixos-24.05";
    };
    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:anthonyroussel/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-secrets = {
      url = "github:anthonyroussel/nix-secrets";
      flake = false;
    };
    stylix = {
      url = "github:danth/stylix?ref=release-24.05";
    };
  };

  outputs =
    {
      nix-secrets,
      nixpkgs,
      nur,
      sops-nix,
      stylix,
      ...
    }@inputs:
    rec {
      nixosModules = import ./modules;

      nixosConfigurations.rsl-xps = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = (import ./modules/module-list.nix) ++ [
          nur.nixosModules.gns3-gui
          # nur.nixosModules.gns3-server
          sops-nix.nixosModules.sops
          stylix.nixosModules.stylix
          ./machines/rsl-xps/configuration.nix
        ];
        specialArgs = {
          inherit
            inputs
            system
            nix-secrets
            nur
            ;
        };
      };

      nixosConfigurations.rsl-ap = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = (import ./modules/module-list.nix) ++ [
          nur.nixosModules.gns3-gui
          sops-nix.nixosModules.sops
          stylix.nixosModules.stylix
          ./machines/rsl-ap/configuration.nix
        ];
        specialArgs = {
          inherit
            inputs
            system
            nix-secrets
            nur
            ;
        };
      };

      nixosConfigurations.rsl-rpi = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = (import ./modules/module-list.nix) ++ [
          sops-nix.nixosModules.sops
          ./machines/rsl-rpi/configuration.nix
        ];
        specialArgs = {
          inherit nix-secrets;
        };
      };

      images.rsl-rpi = nixosConfigurations.rsl-rpi.config.system.build.sdImage;

      defaultPackage.x86_64-linux = nixosConfigurations.rsl-xps.config.system.build.toplevel;
      legacyPackages.x86_64-linux = nixosConfigurations.rsl-xps.pkgs;
    };
}
