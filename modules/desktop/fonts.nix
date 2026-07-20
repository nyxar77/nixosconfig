{ pkgs, ... }: {
  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      poppins
      fira-code
      fira-code-symbols
      material-symbols
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono

      noto-fonts
      noto-fonts-cjk-sans
      liberation_ttf
      dejavu_fonts
    ];
  };
}
