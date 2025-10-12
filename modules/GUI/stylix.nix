{
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf (config.desktopManagers.enable) {
    stylix = {
      enable = true;
      autoEnable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/Catppuccin-Macho.yaml";
      image = null;
      /*
         base16Scheme = {
        base00 = "#211e2a";
        base01 = "#2c2737";
        base02 = "#3f3951";
        base03 = "#6e6780";
        base04 = "#8a829e";
        base05 = "#e4dee9";
        base06 = "#f2e8f0";
        base07 = "#ffffff";
        base08 = "#e965a5";
        base09 = "#f4b870";
        base0A = "#ebde76";
        base0B = "#b1f2a7";
        base0C = "#b3f4f3";
        base0D = "#95a6f4";
        base0E = "#ff79c6";
        base0F = "#bd93f9";
      };
      */
    };

    # stylix.fonts = {
    #   serif = config.stylix.fonts.monospace;
    #   sansSerif = config.stylix.fonts.monospace;
    #   emoji = config.stylix.fonts.monospace;
    # };
  };
}
