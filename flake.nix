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
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    /*
       chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    */
  };
  outputs = inputs @ {
    flake-parts,
    nixpkgs,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      flake = let
        hostSystem = "x86_64-linux";
        mkPkgs = system:
          import nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
              permittedInsecurePackages = ["openssl-1.1.1w"];
            };
            overlays = [];
          };

        mkHost = {
          name,
          system ? hostSystem,
          pkgs ? null,
          extraModules ? [],
          specialArgs ? {},
        }:
          nixpkgs.lib.nixosSystem ({
              modules =
                [
                  ./hosts/${name}
                  ./modules/options.nix
                ]
                ++ extraModules;

              specialArgs =
                {
                  inherit inputs;
                }
                // specialArgs;
            }
            // (
              if pkgs == null
              then {inherit system;}
              else {inherit pkgs;}
            ));

        pkgs = mkPkgs hostSystem;
      in {
        nixosConfigurations = {
          nixos = mkHost {
            name = "nixos";
            inherit pkgs;
            extraModules = [
              inputs.sops-nix.nixosModules.sops

              /*
                 inputs.chaotic.nixosModules.nyx-cache
              inputs.chaotic.nixosModules.nyx-overlay
              inputs.chaotic.nixosModules.nyx-registry
              */
            ];
          };

          serverless = mkHost {
            name = "serverless";
          };
        };
      };
    };
}
