{
  # Enable sound.
  sound.enable = true;

  # Disable pulseaudio
  hardware.pulseaudio.enable = false;

  # And use pipewire instead for Wayland
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
}
