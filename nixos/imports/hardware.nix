{pkgs, ...}: {
  hardware = {
    # Bluetooth.
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;

    graphics = {
      enable = true;
      extraPackages = with pkgs; [amdvlk];
    };
  };
}
