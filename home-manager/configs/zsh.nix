{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initExtraFirst = ''
      [[ "$TERM" == "linux" ]] && return
    '';

    initExtra = ''
      source <(nh completions --shell zsh)
      eval "$(zoxide init zsh)"
      [[ -z "$TERM" ]] && exec tmux
    '';

    shellAliases = {
      ".." = "cd ..";
      ls = "exa";
      vim = "nvim";
      grep = "rg";
      du = "dust";
      rm = "rip";
      cp = "xcp";
      update-os = "nh os switch ~/.dotfiles";
      update-home = "nh home switch ~/.dotfiles";
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
  };
}
