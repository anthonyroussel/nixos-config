{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/sops
      ../../users/aroussel.nix
      ../../users/root.nix
    ];

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi3;
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  # Workaround: https://github.com/NixOS/nixpkgs/issues/154163
  # modprobe: FATAL: Module sun4i-drm not found in directory
  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // {allowMissing = true;});
    })
  ];

  services.openssh = {
    enable = true;
  };

  environment.systemPackages = [
    pkgs.git
    pkgs.libraspberrypi
    pkgs.raspberrypifw
    pkgs.vim
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };

  networking = {
    # Define your hostname.
    hostName = "rsl-rpi";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
