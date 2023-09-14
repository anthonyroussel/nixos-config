{ config, nix-secrets, pkgs, ... }:

{
  programs.gnupg.enable = true;

  environment.systemPackages = [ pkgs.pinentry-curses ];

  sops = {
    gnupg = {
      home = "/var/lib/sops";
      sshKeyPaths = [];
    };
    defaultSopsFile = "${nix-secrets}/${config.networking.hostName}.yaml";
  };
}
