{ inputs, config, lib, sops, pkgs, ... }:
{
  sops.secrets."passwords/aroussel" = {
    neededForUsers = true;
  };

  users = {
    users = {
      aroussel = {
        uid = 1000;
        isNormalUser = true;
        group = "aroussel";
        description = "Anthony Roussel";

        # Enable ‘sudo’ for the user.
        extraGroups = [ "wheel" ]
          ++ lib.optionals config.networking.networkmanager.enable [ "networkmanager" ]
          ++ lib.optionals config.virtualisation.docker.enable [ "docker" ]
          ++ lib.optionals config.security.tpm2.enable [ "tss" ];

        # Generate the password with `mkpasswd -m sha-512 > passwords/aroussel`
        passwordFile = config.sops.secrets."passwords/aroussel".path;

        # Path to encrypted luks device that contains the user's home directory.
        cryptHomeLuks = "/dev/pool/home-aroussel";

        # Switch to Home Manager instead
        packages = with pkgs; [
          # Various tools
          zbar # Barcode reader
          translate-shell # Google Translate

          # Developer tools
          vscodium
          jq
          tmux
          nixpkgs-fmt

          # Office
          libreoffice
          calibre

          # Audio / video
          vorbis-tools # OGG codec
          vlc

          # Imaging
          gimp
          imagemagick

          # Browser
          chromium

          # Messaging
          discord

          # System tools
          borgbackup # Borg backup tool

          # Dev tools (use nix-direnv instead)
          #
          # Cloud tools
          inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.awscli2
          inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.awsebcli
          inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.google-cloud-sdk
          inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.kubectl

          # Dev tools
          inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.chezmoi
          inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.doctl
          inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.gh
          inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.hugo

          # Node.js
          inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.nodejs-18_x
          inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.nodePackages.yarn

          # Password management
          inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.gopass
          inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.gopass-jsonapi

          # Python
          inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.python3
          inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.python3Packages.pip
          inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.pipenv

          inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.buku

          # (inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.buku.override {
          #   withServer = true;
          # })

          # Infra as Code (IaC)

          inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.terraform
          inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.terraform-ls
          inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.pulumi-bin

          # AWS
          inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.nodePackages.serverless
        ];
      };
    };

    # User-Private Group (UPG)
    groups = {
      aroussel = {
        gid = 1000;
        name = "aroussel";
        members = [ "aroussel" ];
      };
    };
  };
}
