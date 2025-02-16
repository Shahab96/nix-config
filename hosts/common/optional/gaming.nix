{
  pkgs,
  ...
}:

{
  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };

    # to run steam games in game mode, add the following to the game's properties from within steam
    # gamemoderun %command%
    gamemode.enable = true;
  };

  environment.systemPackages = with pkgs; [
    mangohud
    protonup-qt
  ];
}
