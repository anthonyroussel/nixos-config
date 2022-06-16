{ pkgs, ... }:
{
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;

    desktopManager.gnome = {
      enable = true;
      extraGSettingsOverrides = ''
        [org.gnome.desktop.calendar]
        show-weekdate=true

        [org.gnome.desktop.interface]
        color-scheme='prefer-dark'
        clock-show-seconds=true
        clock-show-weekday=true
        gtk-theme='Adwaita-dark'
        show-battery-percentage=true
        text-scaling-factor=1.05

        [org.gnome.desktop.sound]
        event-sounds=false
      '';

      extraGSettingsOverridePackages = [
        pkgs.gsettings-desktop-schemas # for org.gnome.desktop
      ];
    };

    # Configure keymap in X11
    layout = "fr";

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
  };

  # Install Gnome Shell extensions
  environment.systemPackages = with pkgs; [
    gnome.dconf-editor
    gnome.gnome-screenshot
    gnome.gnome-tweaks

    gnomeExtensions.applications-menu
    gnomeExtensions.disconnect-wifi
    gnomeExtensions.openweather
    gnomeExtensions.places-status-indicator
    gnomeExtensions.removable-drive-menu
    gnomeExtensions.sound-output-device-chooser
    gnomeExtensions.user-themes
    gnomeExtensions.vitals
    gnomeExtensions.workspace-indicator

    glxinfo
  ];
}
