{ ... }: 

{
  specialisation.powersave.configuration = {
    services.power-profiles-daemon.enable = false;

    services.tlp = {
      enable = true;

      settings = {
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_SCALING_GOVERNOR_ON_AC = "powersave";
        CPU_ENERGY_PREF_ON_BAT = "power";
        CPU_ENERGY_PREF_ON_AC = "power";

        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;

        CPU_HWP_DYN_BOOST_ON_AC=1;
        CPU_HWP_DYN_BOOST_ON_BAT=0;

        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_BAT = 20;
        CPU_MAX_PERF_ON_AC = 100;

        AMDGPU_ABM_LEVEL_ON_AC=0;
        AMDGPU_ABM_LEVEL_ON_BAT=3;

        PLATFORM_PROFILE_ON_AC="performance";
        PLATFORM_PROFILE_ON_BAT="low-power";

        START_CHARGE_THRESH_BAT0 = 20;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
  };
}
