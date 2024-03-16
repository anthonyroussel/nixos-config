{ config, pkgs, ... }:

{
  sops.secrets."nix/secret-key-file" = { };

  # Enable experimental support for Nix flakes
  nix = {
    # https://nixos.org/manual/nix/stable/release-notes/rl-2.18.html
    package = pkgs.nix;
    settings = {
      allowed-users = [ "aroussel" ];
      secret-key-files = [
        # Secret key file for nix-cache.roussel.dev
        config.sops.secrets."nix/secret-key-file".path
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-cache.roussel.dev:rqdQw2TpTz3hrT+JvEAbsEH6fhk1AdX9zhBN0sGnEE8="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-substituters = [ "https://nix-cache.roussel.dev" ];
      substituters = [
        "https://cache.nixos.org"
        "https://nixpkgs-wayland.cachix.org"
        "https://nix-community.cachix.org"
      ];
    };

    extraOptions = "experimental-features = nix-command flakes";

    # Automatically clear Nix store every 7 days
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
