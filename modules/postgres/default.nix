{ config, lib, ... }:

let
  cfg = config.rsl.postgres;

in {
  options.rsl.postgres.enable = lib.mkEnableOption "custom postgres";

  config = lib.mkIf cfg.enable {
    containers.postgres = {
      autoStart = true;

      forwardPorts = [
        {
          protocol = "tcp";
          hostPort = 5432;
          containerPort = 5432;
        }
      ];

      bindMounts = {
        "/var/lib/postgresql" = {
          hostPath = "/var/lib/postgresql";
          isReadOnly = false;
        };
      };

      config =
        { config, pkgs, ... }:
        {
          services.postgresql = {
            enable = true;
            package = pkgs.postgresql_16;
            authentication = ''
              host lafourmiliere lafourmiliere all trust
            '';
            ensureDatabases = [ "lafourmiliere" ];
            ensureUsers = [
              {
                name = "lafourmiliere";
                ensureDBOwnership = true;
                ensureClauses = {
                  superuser = true;
                  createrole = true;
                  createdb = true;
                };
              }
            ];
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
  };
}
