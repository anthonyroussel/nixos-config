{ pkgs, ... }:
{
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
}
