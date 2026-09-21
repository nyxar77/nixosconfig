{
  description = "nixos system configuration";

  inputs = {
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

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-guiutils = {
      url = "github:hyprwm/hyprland-guiutils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    /*
         chaotic = {
        url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    */
  };
  outputs =
    inputs@{
      flake-parts,
      nixpkgs,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      flake =
        let
          hostSystem = "x86_64-linux";
          hostNames = {
            workstation = "nixos";
            server = "serverless";
          };
          mkPkgs =
            system:
            import nixpkgs {
              inherit system;
              config = {
                allowUnfree = true;
                permittedInsecurePackages = [ "openssl-1.1.1w" ];
              };
              overlays = [
                (final: prev: {
                  hyprland-qtutils = inputs.hyprland-guiutils.packages.${system}.hyprland-guiutils;
                })
              ];
            };

          mkHost =
            {
              name,
              system ? hostSystem,
              pkgs ? null,
              extraModules ? [ ],
              specialArgs ? { },
            }:
            nixpkgs.lib.nixosSystem (
              {
                modules = [
                  ./hosts/${name}
                  ./modules/options.nix
                  inputs.sops-nix.nixosModules.sops
                  inputs.silentSDDM.nixosModules.default

                  {
                    nyx.host.name = name;
                  }
                ]
                ++ extraModules;

                specialArgs = {
                  inherit inputs hostNames;
                }
                // specialArgs;
              }
              // (if pkgs == null then { inherit system; } else { inherit pkgs; })
            );

          pkgs = mkPkgs hostSystem;
        in
        {
          nixosConfigurations = {
            ${hostNames.workstation} = mkHost {
              name = hostNames.workstation;
              inherit pkgs;
              extraModules = [
                /*
                  inputs.chaotic.nixosModules.nyx-cache
                  inputs.chaotic.nixosModules.nyx-overlay
                  inputs.chaotic.nixosModules.nyx-registry
                */
              ];
            };

            ${hostNames.server} = mkHost {
              name = hostNames.server;
              extraModules = [ inputs.disko.nixosModules.disko ];
            };
          };
        };
    };
}
