{ config, ... }:

{
  sops.secrets."nix-builders/darwin-build-box-ssh-key" = {};

  programs.ssh.knownHosts."darwin-build-box.nix-community.org".publicKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKX7W1ztzAtVXT+NBMITU+JLXcIE5HTEOd7Q3fQNu80S";

  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "darwin-build-box.nix-community.org";
        maxJobs = 4;
        sshUser = "anthonyroussel";
        sshKey = config.sops.secrets."nix-builders/darwin-build-box-ssh-key".path;
        supportedFeatures = [ "big-parallel" ];
        systems = [ "aarch64-darwin" "x86_64-darwin" ];
      }
    ];
  };
}
