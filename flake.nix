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
      url = "github:nix-community/NUR";
    };
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-secrets = {
      url = "git+file:./secrets";
      flake = false;
    };
  };

  outputs = { nixpkgs, nixos-hardware, sops-nix, nixos-generators, home-manager, nur, nix-secrets, self, ... }@inputs: rec {
    # rsl-xps
    nixosConfigurations.rsl-xps = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules = [
        sops-nix.nixosModules.sops
        nur.nixosModules.nur
        ./machines/rsl-xps/configuration.nix
      ];
      specialArgs = { inherit inputs system nix-secrets; };
    };

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
