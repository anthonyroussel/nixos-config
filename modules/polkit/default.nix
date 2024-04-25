{ config, lib, ... }:

let
  cfg = config.rsl.polkit;

in {
  options.rsl.polkit.enable = lib.mkEnableOption "custom polkit";

  config = lib.mkIf cfg.enable {
    security.polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (action.id == "org.freedesktop.machine1.shell") {
            if (subject.isInGroup("wheel")) {
              return polkit.Result.YES;
            }
          }
        });
      '';
    };
  };
}
