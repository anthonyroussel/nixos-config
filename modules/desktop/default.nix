{ config, lib, ... }:

let
  cfg = config.rsl.desktop;

in {
  options.rsl.desktop.enable = lib.mkEnableOption "custom desktop";

  config = lib.mkIf cfg.enable {
    # Enable dconf
    programs.dconf.enable = true;

    # Use SDDM as Desktop Manager.
    services.displayManager.sddm.enable = true;

    # Enable the X11 windowing system.
    services.xserver = {
      enable = true;

      # Configure keymap in X11
      xkb.layout = "fr";

      # Use Xfce & Plasma
      desktopManager.plasma5.enable = true;
    };
  };
}
