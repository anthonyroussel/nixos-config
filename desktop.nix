{ pkgs, ... }:
{
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    # Configure keymap in X11
    layout = "fr";
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Install Gnome Shell extensions
  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    gnomeExtensions.applications-menu
    gnomeExtensions.disconnect-wifi
    gnomeExtensions.openweather
    gnomeExtensions.places-status-indicator
    gnomeExtensions.removable-drive-menu
    gnomeExtensions.sound-output-device-chooser
    gnomeExtensions.vitals
    gnomeExtensions.workspace-indicator
  ];
}
