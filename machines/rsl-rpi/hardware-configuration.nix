{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };

  boot.loader.raspberryPi = {
    enable = true;
    version = 3;
  };
  boot.loader.raspberryPi.uboot.enable = true;

  hardware.enableRedistributableFirmware = true;
}
