{
  description = "NixOS system-wide configuration";

  inputs = {
    nixpkgs = {
      url = "nixpkgs/nixos-23.11";
    };
    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:anthonyroussel/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-secrets = {
      url = "github:anthonyroussel/nix-secrets";
      flake = false;
    };
    stylix = {
      url = "github:danth/stylix?ref=release-23.11";
    };
  };

  outputs =
    {
      nixpkgs,
      nixos-hardware,
      sops-nix,
      nixos-generators,
      home-manager,
      nur,
      nix-secrets,
      stylix,
      self,
      ...
    }@inputs:
    rec {
      nixosModules = import ./modules;

      # rsl-xps
      nixosConfigurations.rsl-xps = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [
          nixosModules.vacuum-journalctl-cron
          sops-nix.nixosModules.sops
          stylix.nixosModules.stylix
          nur.nixosModules.gns3-gui
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

      # rsl-rpi
      nixosConfigurations.rsl-rpi = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          nixosModules.vacuum-journalctl-cron
          sops-nix.nixosModules.sops
          ./machines/rsl-rpi/configuration.nix
        ];
        specialArgs = {
          inherit nix-secrets;
        };
      };

      images.rsl-rpi = nixosConfigurations.rsl-rpi.config.system.build.sdImage;

      # rsl-cloud
      nixosConfigurations.rsl-cloud = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [
          nixosModules.vacuum-journalctl-cron
          sops-nix.nixosModules.sops
          nur.nixosModules.gns3-server
          ./machines/rsl-cloud/configuration.nix
        ];
        format = "amazon";
        specialArgs = {
          inherit inputs system nix-secrets;
        };
      };

      # DigitalOcean NixOS image generator
      packages.x86_64-linux = {
        digitalocean = nixos-generators.nixosGenerate {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          format = "do";
        };

        # nix build .#rsl-cloud
        rsl-cloud = nixos-generators.nixosGenerate {
          system = "x86_64-linux";
          modules = [
            nixosModules.vacuum-journalctl-cron
            sops-nix.nixosModules.sops
            nixos-generators.nixosModules.amazon
            { amazonImage.sizeMB = 3 * 1024; }
            ./machines/rsl-cloud/configuration.nix
          ];
          format = "amazon";
          specialArgs = {
            inherit nix-secrets;
          };
        };
      };

      defaultPackage.x86_64-linux = nixosConfigurations.rsl-xps.config.system.build.toplevel;
      legacyPackages.x86_64-linux = nixosConfigurations.rsl-xps.pkgs;
    };
}
