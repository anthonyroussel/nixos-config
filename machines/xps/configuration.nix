# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, nixos-hardware, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ../../users/root.nix
      ../../users/aroussel.nix

      ../../modules/sops
      ../../modules/gnome
      ../../modules/shadow
      ../../modules/sound
      ../../modules/tlp
      ../../modules/yubikey
      ../../modules/wireless
      ./nftables.nix

      # https://github.com/NixOS/nixos-hardware
      #
      "${inputs.nixos-hardware}/dell/xps/15-9560/nvidia"
      "${inputs.nixos-hardware}/common/pc/laptop/ssd"
      "${inputs.nixos-hardware}/common/cpu/intel/kaby-lake"
    ];

  # Enable experimental support for Nix flakes
  nix = {
    package = pkgs.nix_2_7;
    allowedUsers = [ "aroussel" ];
    extraOptions = "experimental-features = nix-command flakes";
  };

  # Use the Grub2 EFI boot loader.
  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      grub = {
        enable = true;
        device = "nodev";
        useOSProber = true;
        efiSupport = true;
        extraEntries = ''
          menuentry "System setup" {
            fwsetup
          }
        '';
      };
    };
    kernelPackages = pkgs.linuxPackages_5_17;
  };

  networking = {
    # Define your hostname.
    hostName = "xps";

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
  };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    # Change default system shell to `zsh`
    defaultUserShell = pkgs.zsh;
  };

  # Enable libpam-mount for cryptHomeLuks
  security.pam.mount.enable = true;

  # Include ~/bin/ in $PATH.
  environment.homeBinInPath = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    htop
    bash-completion
    gnupg

    # Browser
    chromium

    # Messaging
    discord

    # Fonts
    corefonts
    dejavu_fonts

    # Password management
    gopass
    gopass-jsonapi

    # Developer tools
    vscodium
    jq
    google-cloud-sdk
    tmux
    nixpkgs-fmt

    # Node.js
    nodejs-17_x
    nodePackages.yarn

    # Python
    python3
    python3Packages.pip
    pipenv

    # Audio / video
    vorbis-tools # OGG codec
    vlc

    # Network tools
    dig # DNS lookup utility
    mtr # My Traceroute

    # System tools
    ntfs3g # MS-NTFS driver
    efibootmgr # EFI boot manager
    cryptsetup
    killall
    unzip
    file
    pciutils # lspci
    usbutils # lsusb
    openssl
    borgbackup # Borg backup tool
    tree
    nload # Show the network usage
    zbar # Barcode reader
    sops # Secret manager for Ops
  ];

  # Allow installation of unfree packages
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "corefonts"
    "discord"
    "shadow-prod"
    "nvidia-x11"
    "nvidia-settings"
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable Git LFS (Large File Storage).
  programs.git = {
    enable = true;
    lfs = {
      enable = true;
    };
  };

  # Set vim as the default editor
  programs.vim = {
    defaultEditor = true;
  };

  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "python" "man" ];
      theme = "agnoster";
    };
  };

  # Enable the Firmware update manager service.
  services.fwupd = {
    enable = true;
  };

  # Disable the Avahi mDNS daemon (useless).
  services.avahi = {
    enable = false;
  };

  # Install Docker
  virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}
