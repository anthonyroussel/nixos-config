{ config, lib, ... }:

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
      xkb.layout = "fr";

      # Use GDM as Display manager
      displayManager.gdm.enable = true;

      # Use Gnome Shell
      desktopManager.gnome.enable = true;
    };
  };
}
