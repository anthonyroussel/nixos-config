{
  desktop = import ./desktop;
  firewall = import ./firewall;
  gns3 = import ./gns3;
  libvirt = import ./libvirt;
  mailhog = import ./mailhog;
  nix-builders = import ./nix-builders;
  polkit = import ./polkit;
  postgres = import ./postgres;
  printers = import ./printers;
  sound = import ./sound;
  stylix = import ./stylix;
  tpm = import ./tpm;
  vacuum-journalctl-cron = import ./vacuum-journalctl-cron.nix;
  wireless = import ./wireless;
  yubikey = import ./yubikey;
}
