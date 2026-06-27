{
  description = "nixos system configuration";

  inputs = {
    # prevPkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05"; # Stable
    # unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    /*
       hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    */
    stylix = {
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = ["openssl-1.1.1w"];
      };
      overlays = [
        (final: prev: {
          openblas = prev.openblas.overrideAttrs (_: {
            doCheck = false;
          });
        })
        /*
           final: prev: {
          base16-schemes = inputs.unstable.legacyPackages.${system}.base16-schemes;
        }
        */
      ];
    };
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit pkgs;
        modules = [
          inputs.stylix.nixosModules.stylix
          ./hosts/nixos
          ./lib
        ];
        specialArgs = {
          inherit inputs;
          inherit (inputs) stylix;
        };
      };

      serverless = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/serverless
          ./lib
        ];
      };
    };
  };
}
