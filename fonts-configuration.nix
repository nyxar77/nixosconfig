{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    poppins
    fira-code
    fira-code-symbols
    nerd-fonts.jetbrains-mono
  ];
}
