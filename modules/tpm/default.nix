{ config, lib, pkgs,... }:

let
  cfg = config.rsl.tpm;

in {
  options.rsl.tpm.enable = lib.mkEnableOption "custom tpm";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      tpm2-tools
      tpm2-tss
    ];

    security.tpm2 = {
      enable = true;
      abrmd = {
        enable = true;
      };
      pkcs11 = {
        enable = true;
      };
    };
  };
}
