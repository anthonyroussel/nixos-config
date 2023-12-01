{
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Enable NAT networking on virtual machines
  networking.nat = {
    enable = true;
    internalInterfaces = [ "virbr0" ];
    externalInterface = "wlan";
    forwardPorts = [ ];
  };
}
