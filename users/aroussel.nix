{
  inputs,
  config,
  lib,
  sops,
  pkgs,
  ...
}:

{
  users = {
    users = {
      aroussel = {
        uid = 1000;
        isNormalUser = true;
        group = "aroussel";
        description = "Anthony Roussel";

        # Enable ‘sudo’ for the user.
        extraGroups =
          [ "wheel" ]
          ++ lib.optionals config.networking.networkmanager.enable [ "networkmanager" ]
          ++ lib.optionals config.security.tpm2.enable [ "tss" ]
          ++ lib.optionals config.virtualisation.libvirtd.enable [ "libvirtd" ]
          ++ lib.optionals config.virtualisation.docker.enable [ "docker" ]
          ++ lib.optionals config.virtualisation.virtualbox.host.enable [ "vboxusers" ];

        # User authorized key for OpenSSH
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8JQEgj4cKTKYz9hKnRgf6pBa0zcR2tfyql04I11W70rhvQ1UuWeAtWeKqmuy9c/BUP+0uCmdp9BycUhHz42b5vgyzDhhxkLAKn4Fs3pMdt3zGybXCmEp9Rfc2i6Bx/nZWYk5qFcLcoNzJDLkKRaCOU5Qh96tj711+/L7HPBSKWh5sg/TXg85aPojcvI664kpjdai98JY/4wJOdmF3RIm/j48oOlL3wWwQZYo5PvAAi41Ta+zBfMezMPKUXPeCOvRtImad6SfDMuxoLsTXtP6ZBJ0HfSkTIhfWDlpCVWnnN3vrq9U55UjE+kQXLsm/GigK9168fNg6Y1sjcpfb1u+s+kjNjLIskK/mHhLoEyhTOY6J5bDeRs52TeyEtPbgKXM5GOib9O9u6SwzfsyBt5XbxoK6pIkpKwxHf8lncZfG3xaDxB7W2y4pgaeZyylH3+2n+c78Z4L/8EEYOt0H5MCfPbkpkws89OZFgddVhB/mpEYts+PfGmmT2hdTWGCEGu8= aroussel@roussel.dev"
        ];
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
