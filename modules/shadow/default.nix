{ config, pkgs, lib, inputs, ... }:
{
  # programs.shadow-client = {
  # Enabled by default when using import
  # enable = true;
  #   channel = "prod";
  # };

  # Provides the `vainfo` command
  environment.systemPackages = with pkgs; [
    config.nur.repos.anthonyroussel.shadow-prod
    libva-utils
  ];

  # Hardware hybrid decoding
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override {
      enableHybridCodec = true;
    };
  };
}
