{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bash-completion
    # cachix
    corefonts
    cryptsetup
    curl
    dejavu_fonts
    dig
    efibootmgr
    gnupg
    home-manager
    htop
    man-pages
    man-pages-posix
    ntfs3g
    openssl
    pciutils
    pinentry
    pinentry-curses
    sbctl
    udev
    usbutils
    vim
    wget
  ];
}
