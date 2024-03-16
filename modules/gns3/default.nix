{
  config,
  lib,
  nur,
  inputs,
  ...
}:

{
  sops.secrets."gns3/password" = { };

  programs.gns3-gui.enable = true;

  containers.gns3-server = {
    autoStart = true;

    bindMounts = {
      "/run/secrets/gns3-password" = {
        hostPath = config.sops.secrets."gns3/password".path;
        isReadOnly = true;
      };
    };

    forwardPorts = [
      {
        protocol = "tcp";
        hostPort = 3080;
        containerPort = 3080;
      }
    ];

    specialArgs = {
      inherit (inputs) nur;
    };

    config =
      { config, pkgs, ... }:
      {
        imports = [ nur.nixosModules.gns3-server ];

        services.gns3-server = {
          enable = true;
          dynamips.enable = true;
          ubridge.enable = true;
          vpcs.enable = true;
          auth = {
            enable = true;
            user = "gns3";
            passwordFile = "/run/secrets/gns3-password";
          };
        };

        system.stateVersion = "23.11";

        networking = {
          firewall = {
            enable = true;
            allowedTCPPorts = [ 3080 ];
          };

          # Use systemd-resolved inside the container
          useHostResolvConf = lib.mkForce false;
        };

        services.resolved.enable = true;
      };
  };
}
