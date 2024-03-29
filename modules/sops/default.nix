{
  config,
  nix-secrets,
  pkgs,
  ...
}:

{
  environment.systemPackages = [
    pkgs.age
    pkgs.sops
  ];

  sops = {
    age = {
      # This is using an age key that is expected to already be in the filesystem
      keyFile = "/var/lib/sops-nix/key.txt";
      # This will generate a new key if the key specified above does not exist
      generateKey = true;
      # This will automatically import SSH keys as age keys
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };
    defaultSopsFile = "${nix-secrets}/nixos/${config.networking.hostName}.yaml";
  };
}
