{
  config,
  ...
}:

{
  programs.alacritty = {
    enable = true;

    settings = {
      window = {
        padding = {
          x = 4;
          y = 8;
        };
        decorations = "full";
        opacity = 1;
        startup_mode = "Windowed";
        title = "Alacritty";
        dynamic_title = true;
        decorations_theme_variant = "None";
      };

      env = {
        TERM = "xterm-256color";
      };

      terminal.shell.program = "zsh";

      font = {
        size = 14;
        normal.family = config.hostSpec.font;
        bold.family = config.hostSpec.font;
        italic.family = config.hostSpec.font;
      };

      cursor = {
        style = "Block";
      };

      general.live_config_reload = true;
    };
  };
}
