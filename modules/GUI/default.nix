{
  lib,
  config,
  ...
}: {
  imports = [
    ./desktop-manager.nix
    ./stylix.nix
    ./tty.nix
  ];
}
