{ lib, ... }: {
  # nixpkgs.config.allowUnfree = true;

  nix = {
    channel.enable = false;

    gc = {
      automatic = true;
      persistent = true;
      dates = "weekly";

      options = lib.mkDefault "--delete-older-than 15d";
    };
    optimise.automatic = true;
    settings = {
      accept-flake-config = true;
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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
}
