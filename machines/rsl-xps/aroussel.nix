{
  inputs,
  config,
  lib,
  sops,
  pkgs,
  ...
}:

{
  sops.secrets."passwords/aroussel" = {
    neededForUsers = true;
  };

  # Generate the password with `mkpasswd -m sha-512 > passwords/aroussel`
  users.users.aroussel.hashedPasswordFile = config.sops.secrets."passwords/aroussel".path;
}
