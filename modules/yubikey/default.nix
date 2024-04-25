{ config, lib, pkgs,... }:

let
  cfg = config.rsl.yubikey;

in {
  options.rsl.yubikey.enable = lib.mkEnableOption "custom yubikey";

  config = lib.mkIf cfg.enable {
    services.udev.packages = [ pkgs.yubikey-personalization ];

    # Enable PCSCD daemon (Smart Card)
    services.pcscd = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      yubikey-manager
      pcsclite
      pcsctools
    ];
  };
}
