{ config, lib, pkgs, ... }:

let
  cfg = config.rsl.libvirt;

in {
  options.rsl.libvirt.enable = lib.mkEnableOption "custom libvirt";

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;

    # Enable NAT networking on virtual machines
    networking.nat = {
      enable = true;
      internalInterfaces = [ "virbr0" ];
      externalInterface = "wlan";
      forwardPorts = [ ];
    };
  };
}
