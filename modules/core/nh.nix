{ ... }: {
  programs.nh = {
    enable = true;
    flake = "/etc/nixos";

    # Nix GC is already configured in common/nix-settings.nix.
    clean.enable = false;
  };
}
