{...}: {
  imports = [./fonts-configuration.nix ./general.nix ./nix-settings.nix];
  security.polkit.enable = true;
}
