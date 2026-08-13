{pkgs, ...}: {
  fonts = {
    # Oui : fournit DejaVu, Liberation, CJK, emoji, Unifont, etc.
    enableDefaultPackages = true;

    packages = with pkgs; [
      # Police principale de l’interface
      inter

      # Couverture Unicode et arabe
      noto-fonts

      # Terminal et code
      jetbrains-mono

      nerd-fonts.symbols-only
    ];

    fontconfig = {
      enable = true;
      antialias = true;

      hinting = {
        enable = true;
        autohint = false;
        style = "slight";
      };

      defaultFonts = {
        sansSerif = [
          "Inter"
          "Noto Sans"
          "Noto Sans Arabic"
          "DejaVu Sans"
        ];

        serif = [
          "Noto Serif"
          "Noto Serif Arabic"
          "DejaVu Serif"
        ];

        monospace = [
          "JetBrains Mono"
          "Noto Sans Mono"
          "DejaVu Sans Mono"
        ];

        emoji = [
          "Noto Color Emoji"
        ];
      };
    };
  };
}
