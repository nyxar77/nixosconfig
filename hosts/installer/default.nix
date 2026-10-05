{
  inputs,
  modulesPath,
  pkgs,
  ...
}:

let
  installServerless = pkgs.writeShellApplication {
    name = "install-serverless";
    runtimeInputs = [
      pkgs.age
      inputs.disko.packages.${pkgs.stdenv.hostPlatform.system}.disko
      pkgs.coreutils
      pkgs.gawk
      pkgs.openssh
      pkgs.ssh-to-age
      pkgs.sops
      pkgs.util-linux
    ];
    text = builtins.readFile ./install-serverless.sh;
  };
in
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  networking = {
    hostName = "nyx-installer";
    networkmanager.enable = true;
  };

  console.keyMap = "fr";

  # Keep the normal kernel, modules, and firmware for broad installer hardware support.
  boot.kernelPackages = pkgs.linuxPackages;
  boot.zfs.forceImportRoot = false;
  hardware.enableRedistributableFirmware = true;

  environment = {
    systemPackages = [
      installServerless
      pkgs.networkmanager
    ];
    etc."nyx-config".source = inputs.self.outPath;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "26.05";
}
