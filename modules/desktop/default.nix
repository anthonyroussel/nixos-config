{ config, lib, pkgs, ... }:

let
  cfg = config.rsl.desktop;

in {
  options.rsl.desktop.enable = lib.mkEnableOption "custom desktop";

  config = lib.mkIf cfg.enable {
    # Enable dconf
    programs.dconf.enable = true;

    # Enable the X11 windowing system.
    services.xserver = {
      enable = true;

      # Configure keymap in X11
      layout = "fr";

      # Use SDDM and Xfce Plasma
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;
      desktopManager.xfce.enable = true;
    };
  };
}
