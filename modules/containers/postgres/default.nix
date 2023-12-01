{ lib, ... }:

{
  containers.postgres = {
    autoStart = true;

    forwardPorts = [
      {
        protocol = "tcp";
        hostPort = 5432;
        containerPort = 5432;
      }
    ];

    config = { config, pkgs, ... }: {
      services.postgresql = {
        enable = true;
        package = pkgs.postgresql_16;
      };

      system.stateVersion = "23.11";

      networking = {
        firewall = {
          enable = true;
          allowedTCPPorts = [ 5432 ];
        };

        # Use systemd-resolved inside the container
        useHostResolvConf = lib.mkForce false;
      };

      services.resolved.enable = true;
    };
  };
}
