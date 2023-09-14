{ config, nix-secrets, ... }:
{
  sops = {
    gnupg = {
      home = "/var/lib/sops";
      sshKeyPaths = [];
    };
    defaultSopsFile = "${nix-secrets}/${config.networking.hostName}.yaml";
  };
}
