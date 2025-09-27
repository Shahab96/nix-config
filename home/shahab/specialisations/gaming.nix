{pkgs, ...}: {
  home.packages = with pkgs; [
    discord
    protonmail-desktop
    protonvpn-gui
    kitty
    waybar
    prismlauncher
  ];
}
