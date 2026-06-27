{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    pavucontrol
    wl-clipboard
    linux-firmware
    linux-wifi-hotspot
    brightnessctl
    mtr-gui
    nocturne
  ];
}
