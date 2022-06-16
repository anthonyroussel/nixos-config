{ inputs, config, lib, sops, ... }:
{
  sops.secrets."passwords/aroussel" = {
    neededForUsers = true;
  };

  users = {
    users = {
      aroussel = {
        uid = 1000;
        isNormalUser = true;
        group = "aroussel";
        description = "Anthony Roussel";
        # Enable ‘sudo’ for the user.
        extraGroups = [ "wheel" ]
          ++ lib.optionals config.networking.networkmanager.enable [ "networkmanager" ]
          ++ lib.optionals config.virtualisation.docker.enable [ "docker" ]
          ++ lib.optionals config.security.tpm2.enable [ "tss" ];

        # Generate the password with `mkpasswd -m sha-512 > passwords/aroussel`
        passwordFile = config.sops.secrets."passwords/aroussel".path;
        # Path to encrypted luks device that contains the user's home directory.
        cryptHomeLuks = "/dev/pool/home-aroussel";
      };
    };

    # User-Private Group (UPG)
    groups = {
      aroussel = {
        gid = 1000;
        name = "aroussel";
        members = [ "aroussel" ];
      };
    };
  };
}
