{ config, pkgs, font, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        "TERM" = "alacritty";
      };

      terminal.shell.program = "zsh";

      font = {
	size = 12;
        normal.family = font;
        bold.family = font;
        italic.family = font;
      };
    };
  };
}
