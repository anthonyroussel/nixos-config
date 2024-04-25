{ config, lib, ... }:

let
  cfg = config.rsl.sound;

in {
  options.rsl.sound.enable = lib.mkEnableOption "custom sound";

  config = lib.mkIf cfg.enable {
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
  };
}
