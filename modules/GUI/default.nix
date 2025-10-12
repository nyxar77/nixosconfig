{
  lib,
  config,
  ...
}: {
  imports = [
    ./desktop-manager.nix
    ./stylix.nix
    ./hyprland.nix
    ./stylix.nix
    ./tty.nix
  ];
}
