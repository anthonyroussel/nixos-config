{ config, nix-secrets, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.age
  ];

  sops = {
    age = {
      keyFile = "/var/lib/sops-nix/key.txt";
    };
    defaultSopsFile = "${nix-secrets}/${config.networking.hostName}.yaml";
  };
}
