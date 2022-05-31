{ pkgs, ... }:
{
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
}
