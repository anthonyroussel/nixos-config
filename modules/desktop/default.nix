{ pkgs, ... }:

{
  # Enable dconf
  programs.dconf.enable = true;

  # Install xdg-desktop-portal for wlroots
  xdg.portal = {
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    # Configure keymap in X11
    layout = "fr";
  };

  # Required to run sway as desktop manager
  security.polkit.enable = true;
}
