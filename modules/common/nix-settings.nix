{lib, ...}: {
  nixpkgs.config.allowUnfree = true;
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

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];
}
