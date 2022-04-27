{
  # Enable sound.
  sound.enable = true;

  # Use pulseaudio.
  hardware.pulseaudio = {
    enable = true;
    extraConfig = ''
      set-sink-mute 0 yes
      set-source-mute 1 yes
    '';
  };
}
