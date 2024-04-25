{ config, lib, pkgs,... }:

let
  cfg = config.rsl.stylix;

in {
  options.rsl.stylix.enable = lib.mkEnableOption "custom stylix";

  config = lib.mkIf cfg.enable {
    stylix = {
      base16Scheme = "${pkgs.base16-schemes}/share/themes/solarflare.yaml";
      polarity = "dark";

      homeManagerIntegration.followSystem = false;

      fonts = {
        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };

        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans";
        };

        monospace = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans Mono";
        };

        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };

        sizes = {
          applications = 11;
          desktop = 11;
          terminal = 14;
        };
      };

      targets.grub.enable = false;
      targets.plymouth.enable = false;
    };
  };
}
