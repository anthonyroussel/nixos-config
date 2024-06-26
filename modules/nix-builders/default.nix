{ config, lib, ... }:

let
  cfg = config.rsl.nix-builders;

in {
  options.rsl.nix-builders.enable = lib.mkEnableOption "custom nix-builders";

  config = lib.mkIf cfg.enable {
    sops.secrets."nix-builders/darwin-build-box-ssh-key" = { };

    programs.ssh.knownHosts."build-box.nix-community.org".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIElIQ54qAy7Dh63rBudYKdbzJHrrbrrMXLYl7Pkmk88H";

    programs.ssh.knownHosts."darwin-build-box.nix-community.org".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFz8FXSVEdf8FvDMfboxhB5VjSe7y2WgSa09q1L4t099";

    nix = {
      distributedBuilds = true;
      buildMachines = [
        {
          hostName = "darwin-build-box.nix-community.org";
          maxJobs = 4;
          sshUser = "anthonyroussel";
          sshKey = config.sops.secrets."nix-builders/darwin-build-box-ssh-key".path;
          supportedFeatures = [ "big-parallel" ];
          systems = [
            "aarch64-darwin"
            "x86_64-darwin"
          ];
        }
      ];
    };
  };
}
