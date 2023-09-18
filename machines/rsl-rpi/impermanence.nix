{ ... }:

{
  environment.persistence."/persistent" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/fail2ban"
      "/var/lib/nixos"
      "/var/lib/sops-nix"
      "/var/lib/systemd/coredump"
    ];
    files = [
      "/etc/machine-id"
      {
        file = "/etc/ssh/ssh_host_ed25519_key";
        parentDirectory = { mode = "u=rw,g=,o="; };
      }
      {
        file = "/etc/ssh/ssh_host_ed25519_key.pub";
        parentDirectory = { mode = "u=rw,g=r,o=r"; };
      }
      {
        file = "/etc/ssh/ssh_host_rsa_key";
        parentDirectory = { mode = "u=rw,g=,o="; };
      }
      {
        file = "/etc/ssh/ssh_host_rsa_key.pub";
        parentDirectory = { mode = "u=rw,g=r,o=r"; };
      }
    ];
    users.aroussel = {
      directories = [
        "src"
        { directory = ".config/nix"; mode = "0700"; }
        { directory = ".ssh"; mode = "0700"; }
      ];
      files = [
        ".screenrc"
      ];
    };
  };
}
