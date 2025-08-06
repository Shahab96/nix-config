{ pkgs, ... }:

{
  home.packages = with pkgs; [
    discord
    lazygit
    gh
    prismlauncher
    cloudflare-warp
    protonmail-desktop
    protonvpn-gui
    cloudflare-warp
    kubectl
    k9s
    postgresql_17
    kitty
    waybar
    obsidian
  ];
}
