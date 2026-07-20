{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wl-clipboard
    linux-firmware
    linux-wifi-hotspot
    brightnessctl
    mtr-gui
    nocturne
  ];
}
