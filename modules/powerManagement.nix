{...}: {
  services.tlp.enable = false;
  services.power-profiles-daemon.enable = false;

  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };

  # 4. Enable Powertop for extra hardware sleep states
  powerManagement.powertop.enable = true;
}
