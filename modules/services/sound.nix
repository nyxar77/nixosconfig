{ lib, ... }:
{
  # enable bluetooth
  hardware.bluetooth.enable = true;
  # Enable sound with pipewire.
  services.pulseaudio.enable = lib.mkForce false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    wireplumber.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };
}
