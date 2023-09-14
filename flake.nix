{
  description = "NixOS system-wide configuration";

  inputs = {
    nixpkgs = {
      url = "nixpkgs/nixos-23.05";
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
    };
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-secrets = {
      url = "github:anthonyroussel/nix-secrets";
      flake = false;
    };
    stylix = {
      url = "github:danth/stylix?ref=release-23.05";
    };
  };

  outputs = { nixpkgs, nixos-hardware, sops-nix, nixos-generators, home-manager, nur, nix-secrets, stylix, self, ... }@inputs: rec {
    # rsl-xps
    nixosConfigurations.rsl-xps = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules = [
        sops-nix.nixosModules.sops
        stylix.nixosModules.stylix
        nur.nixosModules.gns3-gui
        nur.nixosModules.gns3-server
        ./machines/rsl-xps/configuration.nix
      ];
      specialArgs = { inherit inputs system nix-secrets; };
    };

    # rsl-rpi
    nixosConfigurations.rsl-rpi = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        sops-nix.nixosModules.sops
        ./machines/rsl-rpi/configuration.nix
      ];
      specialArgs = { inherit nix-secrets; };
    };

    images.rsl-rpi = nixosConfigurations.rsl-rpi.config.system.build.sdImage;

    # DigitalOcean NixOS image generator
    packages.x86_64-linux = {
      digitalocean = nixos-generators.nixosGenerate {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        format = "do";
      };
    };

    defaultPackage.x86_64-linux = nixosConfigurations.rsl-xps.config.system.build.toplevel;
    legacyPackages.x86_64-linux = nixosConfigurations.rsl-xps.pkgs;
  };
}
