{ config, lib, ... }:

let
  cfg = config.rsl.mailhog;

in {
  options.rsl.mailhog.enable = lib.mkEnableOption "custom mailhog";

  config = lib.mkIf cfg.enable {
    containers.mailhog = {
      autoStart = true;

      forwardPorts = [
        {
          protocol = "tcp";
          hostPort = 1025;
          containerPort = 1025;
        }
        {
          protocol = "tcp";
          hostPort = 8025;
          containerPort = 8025;
        }
      ];

      config =
        { config, pkgs, ... }:
        {
          services.mailhog = {
            enable = true;
          };

          system.stateVersion = "23.11";

          networking = {
            firewall = {
              enable = true;
              allowedTCPPorts = [
                1025
                8025
              ];
            };

            # Use systemd-resolved inside the container
            useHostResolvConf = lib.mkForce false;
          };

          services.resolved.enable = true;
        };
    };
  };
}
