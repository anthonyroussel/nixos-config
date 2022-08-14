{ inputs, pkgs, ... }:
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "aroussel";
  home.homeDirectory = "/home/aroussel";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
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

    inputs.nixpkgs-review.defaultPackage.x86_64-linux
    inputs.nixpkgs-review-checks.defaultPackage.x86_64-linux
    inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.cached-nix-shell
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
