{
  pkgs,
  inputs,
  ...
}: {
  programs = {
    nix-ld.enable = true;
    dconf.enable = true;
    gamemode.enable = true;

    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };

    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = ["shahab"];
    };

    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
  };
}
