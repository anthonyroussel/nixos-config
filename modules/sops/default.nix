{ config, nix-secrets, ... }:
{
  sops = {
    gnupg = {
      home = "/var/lib/sops";
    };
    defaultSopsFile = "${nix-secrets}/${config.networking.hostName}.yaml";
  };
}
