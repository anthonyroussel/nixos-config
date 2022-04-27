{
  description = "NixOS system-wide configuration";

  inputs = {
    nixpkgs = {
      url = "nixpkgs/nixos-21.11";
    };
    nixos-hardware = {
      url = "github:anthonyroussel/nixos-hardware/fix-xps_9560-primus_deprecations";
    };
    secrets = {
      url = "git+file:///persist/secrets/.git";
    };
    shadow = {
      url = "github:anthonyroussel/shadow-nix/v1.0.6";
      flake = false;
    };
  };

  outputs = { nixpkgs, nixos-hardware, ... }@inputs: rec {
    nixosConfigurations.xps = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules = [ ./machines/xps/configuration.nix ];
      specialArgs = { inherit inputs system; };
    };

    defaultPackage.x86_64-linux = nixosConfigurations.xps.config.system.build.toplevel;
    legacyPackages.x86_64-linux = nixosConfigurations.xps.pkgs;
  };
}
