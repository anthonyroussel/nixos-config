{
  config,
  lib,
  ...
}:

let
  cfg = config.rsl.wireless;

  mkWirelessProfile =
    {
      uuid,
      ssid,
      psk,
    }:
    {
      connection = {
        inherit uuid;
        id = ssid;
        type = "wifi";
        interface-name = "wlan";
        permissions = "";
      };
      wifi = {
        inherit ssid;
        mac-address-blacklist = "";
        mode = "infrastructure";
      };
      wifi-security = {
        inherit psk;
        auth-alg = "open";
        key-mgmt = "wpa-psk";
      };
      ipv4 = {
        dns-search = "";
        method = "auto";
      };
      ipv6 = {
        addr-gen-mode = "stable-privacy";
        dns-search = "";
        method = "auto";
      };
    };

in {
  options.rsl.wireless.enable = lib.mkEnableOption "custom wireless";

  config = lib.mkIf cfg.enable {
    sops.secrets."networkmanager/Livebox-6296/psk" = { };
    sops.secrets."networkmanager/Livebox-D850/psk" = { };
    sops.secrets."networkmanager/Livebox-E3F0/psk" = { };
    sops.secrets."networkmanager/Livebox-8C40/psk" = { };

    sops.templates."networkmanager".content = ''
      LIVEBOX_6296_PSK = "${config.sops.placeholder."networkmanager/Livebox-6296/psk"}"
      LIVEBOX_D850_PSK = "${config.sops.placeholder."networkmanager/Livebox-D850/psk"}"
      LIVEBOX_E3F0_PSK = "${config.sops.placeholder."networkmanager/Livebox-E3F0/psk"}"
      LIVEBOX_8C40_PSK = "${config.sops.placeholder."networkmanager/Livebox-8C40/psk"}"
    '';

    networking.networkmanager.ensureProfiles = {
      environmentFiles = [ /run/secrets-rendered/networkmanager ];
      profiles = {
        "Livebox-6296" = mkWirelessProfile {
          uuid = "d68423d2-d65a-4a79-9f45-608d14b92d5a";
          ssid = "Livebox-6296";
          psk = "$LIVEBOX_6296_PSK";
        };
        "Livebox-D850" = mkWirelessProfile {
          uuid = "b3039850-54f0-4859-ae26-728c4ee6f4c1";
          ssid = "Livebox-D850";
          psk = "$LIVEBOX_D850_PSK";
        };
        "Livebox-E3F0" = mkWirelessProfile {
          uuid = "ade27a61-b441-49a2-bb43-5383a1c94a84";
          ssid = "Livebox-E3F0";
          psk = "$LIVEBOX_E3F0_PSK";
        };
        "Livebox-8C40" = mkWirelessProfile {
          uuid = "d30d92c6-26c5-4ac2-9261-36d567e7aae";
          ssid = "Livebox-8C40";
          psk = "$LIVEBOX_8C40_PSK";
        };
      };
    };
  };
}
