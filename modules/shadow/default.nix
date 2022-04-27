{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    "${inputs.shadow}/import/system.nix"
  ];

  programs.shadow-client = {
    # Enabled by default when using import
    # enable = true;
    channel = "prod";
  };

  # Provides the `vainfo` command
  environment.systemPackages = with pkgs; [
    libva-utils
  ];

  # Hardware hybrid decoding
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override {
      enableHybridCodec = true;
    };
  };
}
