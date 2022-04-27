{ environment, config, sops, ... }:
{
  sops.secrets."wlan/d850" = { };
  sops.secrets."wlan/6296" = { };
  sops.secrets."wlan/e3f0" = { };
  sops.secrets."wlan/redmi" = { };

  environment.etc = {
    "NetworkManager/system-connections/D850.nmconnection" = {
      source = config.sops.secrets."wlan/d850".path;
      mode = "0400";
    };
    "NetworkManager/system-connections/6296.nmconnection" = {
      source = config.sops.secrets."wlan/6296".path;
      mode = "0400";
    };
    "NetworkManager/system-connections/E3F0.nmconnection" = {
      source = config.sops.secrets."wlan/e3f0".path;
      mode = "0400";
    };
    "NetworkManager/system-connections/Redmi.nmconnection" = {
      source = config.sops.secrets."wlan/redmi".path;
      mode = "0400";
    };
  };
}
