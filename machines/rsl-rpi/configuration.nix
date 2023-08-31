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

  users.users.aroussel.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCn9y09hn1G92Yxm7IPnTgcF2V1fKRdH0s2gKSbkY/XpM3aoMscQ3uvTNrdCxpLtGBkaEe67AKfIOdK+TKx1s/QnWELHlL4cgpP9UW7XR/w+XDJqKQZAv83HUIL6QEiLliS63UguHJOrjSK+hlhi/yhsh9lznRYett4nz7ZsrcqQUNwbei1CBfBb2ayS/B0QMzQgSD5uRXV1Sp5HpMZzEvKb0l16/jA+yTxoNIQP1AkjatSJ3CNetdJxOTMnFRp+mXwzS4fMWuiSOeeDXnByZC9VPbBbn8Id4PJhoB2E25oUl9Rb/z8KxKivUwLq/o+v9QXoAWiTBLBK547yrhQdINrsLjOEu31Ilv5oyv6HKq4kxuXMI9iG4oEDgVSnduOJ4M5gQ9VQ72c65yunRVVQT3SFv32B7+qILCvGbc5AmCAV8ST0l6no4HeasiTARFlEszBElcDu1pE0WXRot+pvPJ1dzHznaTt/IxaAv2thEbF5ZrXczkxAl9xZXfRjom9X4s= aroussel@rsl-rpi-3bp"
  ];

  services.openssh = {
    enable = true;
  };

  environment.systemPackages = [
    pkgs.sops
    pkgs.git
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
