{ ... }: {
  # Previous CPU-only power management, kept for reference.
  /*
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

  powerManagement.powertop.enable = true;
  */

  services = {
    power-profiles-daemon.enable = false;
    auto-cpufreq.enable = false;
    tlp = {
      enable = true;
      pd.enable = true;

      settings = {
        # amd-pstate-epp stays dynamic; EPP controls the performance bias.
        CPU_SCALING_GOVERNOR_ON_AC = "powersave";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_SCALING_GOVERNOR_ON_SAV = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
        CPU_ENERGY_PERF_POLICY_ON_SAV = "power";

        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 1;
        CPU_BOOST_ON_SAV = 0;

        # Keep the explicit power-saver profile near the CPU's efficient range.
        CPU_SCALING_MAX_FREQ_ON_SAV = 1113000;

        AMDGPU_ABM_LEVEL_ON_AC = 0;
        AMDGPU_ABM_LEVEL_ON_BAT = 1;
        AMDGPU_ABM_LEVEL_ON_SAV = 3;

        SOUND_POWER_SAVE_ON_AC = 1;
        SOUND_POWER_SAVE_ON_BAT = 1;
        SOUND_POWER_SAVE_CONTROLLER = "Y";

        RUNTIME_PM_ON_AC = "on";
        RUNTIME_PM_ON_BAT = "auto";
        USB_AUTOSUSPEND = 1;
        WOL_DISABLE = "Y";

        # The RTL8852AE is explicitly configured for stability elsewhere.
        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "off";
        RUNTIME_PM_DRIVER_DENYLIST = "mei_me nouveau radeon xhci_hcd rtw89_8852ae";
      };
    };

    logind.settings.Login = {
      # Restore these after adding persistent swap and resume configuration.
      # HandlePowerKey = "hibernate";
      # HandleLidSwitch = "hibernate";
      # HandleLidSwitchExternalPower = "hibernate";
      HandlePowerKey = "suspend";
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "suspend";
      HandleLidSwitchDocked = "ignore";
    };
  };

  systemd.sleep.settings.Sleep = {
    AllowHibernation = false;
    AllowSuspendThenHibernate = false;
    # HibernateMode = "platform shutdown";
  };
}
