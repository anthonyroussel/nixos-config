{ config, lib, pkgs, ... }:

{
  imports =
    [
      ../../modules/sops
      ../../users/aroussel.nix
      ../../users/root.nix
    ];

  environment.systemPackages = [
    pkgs.git
    pkgs.htop
    pkgs.vim
  ];

  services.fail2ban = {
    enable = true;
  };

  services.openssh = {
    enable = true;
  };

  networking = {
    hostName = "rsl-cloud";

    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
