{ pkgs, ... }:

{
  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      brave = {
        executable = "${pkgs.lib.getBin pkgs.brave}/bin/brave";
        desktop = "${pkgs.brave}/share/applications/brave-browser.desktop";
        profile = "${pkgs.firejail}/etc/firejail/brave-browser.profile";
      };
    };
  };
}
