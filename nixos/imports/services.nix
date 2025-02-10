{pkgs, ...}: {
  services = {
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time --cmd ${pkgs.hyprland}/bin/Hyprland";
          user = "greeter";
        };
      };
    };

    # OpenSSH
    openssh.enable = true;

    # Cups printing service
    printing.enable = true;

    # Enable blueman
    blueman.enable = true;

    # Enable smart card services
    pcscd.enable = true;

    # Framework firmware updating
    fwupd.enable = true;

    # Enable sound with pipewire.
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    spice-vdagentd.enable = true;
  };
}
