# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
  inputs,
  nixos-hardware,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../../users/aroussel.nix
    ./aroussel.nix

    ../../users/root.nix
    ../../modules/desktop
    ../../modules/firewall
    ../../modules/gns3
    ../../modules/libvirt
    ../../modules/mailhog
    ../../modules/nix
    ../../modules/nix-builders
    ../../modules/polkit
    ../../modules/postgres
    ../../modules/printers
    ../../modules/sops
    ../../modules/sound
    ../../modules/stylix
    ../../modules/tlp
    ../../modules/tpm
    ../../modules/yubikey
    ../../modules/wireless
    ./opengl.nix
    ./packages.nix
    ./udev.nix

    # https://github.com/NixOS/nixos-hardware
    #
    "${inputs.nixos-hardware}/dell/xps/15-9560"
    "${inputs.nixos-hardware}/dell/xps/15-9560/nvidia"
    "${inputs.nixos-hardware}/common/pc/laptop/ssd"
    "${inputs.nixos-hardware}/common/cpu/intel/kaby-lake"
  ];

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
        enableCryptodisk = true;
        extraEntries = ''
          menuentry "System setup" {
            fwsetup
          }
        '';
      };
    };
  };

  # LUKS-encrypted LVM partition
  boot.initrd.luks.devices = {
    pool2 = {
      device = "/dev/disk/by-uuid/5d329e1e-39c2-46a8-88c0-01cf101ddc82";
      preLVM = true;
      fallbackToPassword = true;
    };
  };

  networking = {
    # Define your hostname.
    hostName = "rsl-xps";

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
  };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr";
  };

  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    # Change default system shell to `zsh`
    defaultUserShell = pkgs.zsh;
  };

  # Enable libpam-mount for cryptHomeLuks
  security.pam.mount.enable = true;

  # Include ~/bin/ in $PATH.
  environment.homeBinInPath = true;

  # Allow installation of unfree packages
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "Oracle_VM_VirtualBox_Extension_Pack"
      "corefonts"
      "nvidia-settings"
      "nvidia-x11"
    ];
  nixpkgs.config.nvidia.acceptLicense = true;

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
    package = pkgs.gitFull;
    config = {
      credential.helper = "${pkgs.gitFull}/bin/git-credential-libsecret";
    };
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
  };

  # Enable the Firmware update manager service.
  services.fwupd = {
    enable = true;
  };

  services.earlyoom = {
    enable = true;
  };

  # Disable the Avahi mDNS daemon (useless).
  services.avahi = {
    enable = false;
  };

  # Install Podman
  virtualisation.podman.enable = true;

  # Clean logs older than 15d
  rsl.vacuum-journalctl-cron.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
