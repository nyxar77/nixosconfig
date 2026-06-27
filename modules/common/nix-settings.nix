{lib, ...}: {
  # nixpkgs.config.allowUnfree = true;
  # Allow experimental feature "flakes"
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix = {
    gc = {
      automatic = true;
      options = lib.mkDefault "--delete-older-than 15d";
    };
    optimise.automatic = true;
  };
  nix.settings.auto-optimise-store = true;
  system = {
    autoUpgrade.enable = true;
    autoUpgrade.dates = lib.mkDefault "weekly";
  };
  nix.channel.enable = false;

  /*
     nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://cachix.cachix.org"
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };
  */

  # nixpkgs.config.permittedInsecurePackages = [
  #   "openssl-1.1.1w"
  # ];
}
