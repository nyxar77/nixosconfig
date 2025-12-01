{
  description = "nixos system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11"; # Stable
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    stylix = {
      url = "github:nix-community/stylix/release-25.05";
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
          ./hosts/nixos
          inputs.stylix.nixosModules.stylix
          ./lib
        ];
        specialArgs = {
          inherit (inputs) stylix;
          hostRole = "nixos";
        };
      };

      serverless = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/serverless
          ./lib
        ];
        specialArgs = {
          hostRole = "serverless";
        };
      };
    };
  };
}
