{ inputs, ... }:
{
  users = {
    users = {
      aroussel = {
        uid = 1000;
        isNormalUser = true;
        group = "aroussel";
        description = "Anthony Roussel";
        # Enable ‘sudo’ for the user.
        extraGroups = [ "wheel" "docker" "networkmanager" ];
        # Generate the password with `mkpasswd -m sha-512 > passwords/aroussel`
        passwordFile = "${inputs.secrets}/files/etc/shadow.d/aroussel";
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
