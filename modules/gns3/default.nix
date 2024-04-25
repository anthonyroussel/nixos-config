{
  config,
  lib,
  ...
}:


let
  cfg = config.rsl.gns3;

in {
  options.rsl.gns3.enable = lib.mkEnableOption "custom gns3";

  config = lib.mkIf cfg.enable {
    sops.secrets."gns3/password" = { };

    programs.gns3-gui.enable = true;

    services.gns3-server = {
      enable = true;
      dynamips.enable = true;
      ubridge.enable = true;
      vpcs.enable = true;
      auth = {
        enable = true;
        user = "gns3";
        passwordFile = config.sops.secrets."gns3/password".path;
      };
    };

    virtualisation.libvirtd.enable = true;
  };
}
