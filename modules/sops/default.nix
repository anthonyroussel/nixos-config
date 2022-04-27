{ config, ... }:
{
  sops = {
    gnupg = {
      home = "/var/lib/sops";
    };
    defaultSopsFile = ../../secrets/${config.networking.hostName}.yaml;
  };
}
