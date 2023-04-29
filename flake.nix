{
  description = "NixOS system-wide configuration";

  inputs = {
    nixpkgs = {
      url = "nixpkgs/nixos-22.11";
    };
    nixpkgs-unstable = {
      url = "nixpkgs/nixos-unstable";
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
    shadow = {
      url = "github:anthonyroussel/shadow-nix";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-review = {
      url = "github:Mic92/nixpkgs-review";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-review-checks = {
      url = "github:SuperSandro2000/nixpkgs-review-checks";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devenv = {
      url = "github:cachix/devenv/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixos-hardware, sops-nix, nixos-generators, home-manager, devenv, ... }@inputs: rec {
    nixosConfigurations.xps = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules = [
        ./machines/xps/configuration.nix
        sops-nix.nixosModules.sops
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.aroussel = import ./home/aroussel.nix;
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ];
      specialArgs = { inherit inputs system; };
    };

    packages.x86_64-linux = {
      digitalocean = nixos-generators.nixosGenerate {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        format = "do";
      };
    };

    defaultPackage.x86_64-linux = nixosConfigurations.xps.config.system.build.toplevel;
    legacyPackages.x86_64-linux = nixosConfigurations.xps.pkgs;
  };
}
