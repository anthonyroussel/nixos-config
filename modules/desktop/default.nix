{ pkgs, ... }:

{
  # Enable dconf
  programs.dconf.enable = true;

  # Install xdg-desktop-portal for wlroots
  xdg.portal = {
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

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

  # Required to run sway as desktop manager
  security.polkit.enable = true;

  # Enable swaylock
  security.pam.services.swaylock.text = ''
    # PAM configuration file for the swaylock screen locker. By default, it includes
    # the 'login' configuration file (see /etc/pam.d/login)
    auth include login
  '';
}
