{ inputs, config, lib, sops, pkgs, ... }:

{
  sops.secrets."passwords/aroussel" = {
    neededForUsers = true;
  };

  users = {
    users = {
      aroussel = {
        # Generate the password with `mkpasswd -m sha-512 > passwords/aroussel`
        hashedPasswordFile = config.sops.secrets."passwords/aroussel".path;

        # Path to encrypted luks device that contains the user's home directory.
        cryptHomeLuks = "/dev/pool/home-aroussel";
      };
    };
  };
}
