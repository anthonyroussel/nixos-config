#
# Get the ID_USB_DRIVER and the ID_PATH values with udevadm:
#
# ```bash
# $ udevadm info --query=all /sys/class/net/lan
# ```
#
{
  systemd.network.links."10-wlan" = {
    matchConfig.Path = "pci-0000:02:00.0";
    linkConfig.Name = "wlan";
  };

  systemd.network.links."20-lan" = {
    matchConfig.Driver = "r8152";
    linkConfig.Name = "lan";
  };

  services.udev.extraRules = ''
    # leezy removable storage
    ACTION=="add", SUBSYSTEM=="block", ATTRS{idVendor}=="0480", ATTRS{idProduct}=="a202", SYMLINK+="uleezy%n"
  '';
}
