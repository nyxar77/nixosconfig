{
  config,
  pkgs,
  ...
}: {
  stylix = {
    enable = true;
    autoEnable = true;
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
    image = /home/nyxar/Pictures/wallpaper-pfp/theme/wallhaven.png;
    base16Scheme = {
      base00 = "282433"; # background
      base01 = "363241";
      base02 = "3f3951"; # selection (from HardHacker)
      base03 = "938aad"; # comment (from HardHacker)
      base04 = "6f6b7b";
      base05 = "eee9fc"; # foreground
      base06 = "cec9dc";
      base07 = "e2ddf0";
      base08 = "e965a5"; # red (from HardHacker)
      base09 = "eaa28e"; # orange (derived mix)
      base0A = "ebde76"; # yellow (from HardHacker)
      base0B = "b1f2a7"; # green (from HardHacker)
      base0C = "b3f4f3"; # cyan (from HardHacker)
      base0D = "b1baf4"; # blue (from HardHacker)
      base0E = "e192ef"; # purple (from HardHacker)
      base0F = "8b7175"; # accent (derived)    };
    };
  };

  # stylix.fonts = {
  #   serif = config.stylix.fonts.monospace;
  #   sansSerif = config.stylix.fonts.monospace;
  #   emoji = config.stylix.fonts.monospace;
  # };
}
