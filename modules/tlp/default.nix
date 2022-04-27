{
  # Disable the Gnome Power Profile daemon (conflicts with TLP)
  services.power-profiles-daemon.enable = false;

  services.tlp = {
    enable = true;
    settings = {
      # Based on these sources:
      # https://github.com/sharipov-ru/dell-xps-9560/blob/master/config/tlp
      # https://linrunner.de/tlp/settings/
      #
      # Set the min/max frequency available for the scaling governor.
      CPU_SCALING_MIN_FREQ_ON_AC = 0;
      CPU_SCALING_MAX_FREQ_ON_AC = 3800000;
      CPU_SCALING_MIN_FREQ_ON_BAT = 0;
      CPU_SCALING_MAX_FREQ_ON_BAT = 800000;

      # PCI Express Active State Power Management (PCIe ASPM)
      PCIE_ASPM_ON_BAT = "powersave";

      # Radio devices to disable on connect.
      DEVICES_TO_DISABLE_ON_LAN_CONNECT = "wifi wwan";
      DEVICES_TO_DISABLE_ON_WIFI_CONNECT = "wwan";
      DEVICES_TO_DISABLE_ON_WWAN_CONNECT = "wifi";

      # Radio devices to enable on disconnect.
      DEVICES_TO_ENABLE_ON_LAN_DISCONNECT = "wifi wwan";
      DEVICES_TO_ENABLE_ON_WIFI_DISCONNECT = "";
      DEVICES_TO_ENABLE_ON_WWAN_DISCONNECT = "";
    };
  };
}
