{
  lib,
  hostRole,
  ...
}: {
  imports =
    [
      ./desktop-manager.nix
      ./tty.nix
    ]
    ++ lib.optionals (hostRole == "nixos") [
      ./stylix.nix
      ./hyprland.nix
    ];
}
