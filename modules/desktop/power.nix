{...}: {
  services.tlp.enable = false;
  services.power-profiles-daemon.enable = false;

  services.logind.settings.Login = {
    HandlePowerKey = "hibernate";
    HandleLidSwitch = "hibernate";
    HandleLidSwitchExternalPower = "hibernate";
    HandleLidSwitchDocked = "ignore";
  };

  systemd.sleep.settings.Sleep = {
    AllowHibernation = true;
    AllowSuspendThenHibernate = true;
    HibernateMode = "platform shutdown";
  };

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
