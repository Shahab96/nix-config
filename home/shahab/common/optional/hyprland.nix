{ config, lib, pkgs, ... }:

{
  home = {
    file = {
      "${config.xdg.configHome}/hypr".source =
        lib.custom.relativeToRoot "dotfiles/hypr";
      "${config.xdg.configHome}/waybar".source =
        lib.custom.relativeToRoot "dotfiles/waybar";
      "${config.xdg.configHome}/wofi".source =
        lib.custom.relativeToRoot "dotfiles/wofi";
      "${config.xdg.configHome}/mako".source =
        lib.custom.relativeToRoot "dotfiles/mako";
    };

    packages = with pkgs; [
      hyprshot
      hyprlock
      hypridle
      hyprpolkitagent
      waybar
      wofi
      mako
    ];
  };
}
