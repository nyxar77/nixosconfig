{lib, ...}: {
  # nixpkgs.config.allowUnfree = true;

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      persistent = true;

      options = lib.mkDefault "--delete-older-than 15d";
    };
    optimise.automatic = true;
    settings = {
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org/"
        "https://hyprland.cachix.org"
        # "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        # "nix-community.cachix.org-1:mB9kiyNJG0XrqcnihK6kQyE3XG8qV7yLs8uYe41rP2Q="
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
  /*
     system = {
    autoUpgrade.enable = true;
    autoUpgrade.dates = lib.mkDefault "weekly";
  };
  */
  nix.channel.enable = false;

  # nixpkgs.config.permittedInsecurePackages = [
  #   "openssl-1.1.1w"
  # ];
}
