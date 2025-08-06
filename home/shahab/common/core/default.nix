{ config, lib, pkgs, hostSpec, ... }: {
  imports = lib.flatten [
    (map lib.custom.relativeToRoot [ "modules/common" "modules/home-manager" ])

    ./ghostty.nix
    ./direnv.nix
    ./git.nix
    ./fonts.nix
  ];

  inherit hostSpec;

  home = {
    username = lib.mkDefault config.hostSpec.username;
    homeDirectory = lib.mkDefault config.hostSpec.home;
    stateVersion = lib.mkDefault "25.05";
    sessionPath = [ "$HOME/.local/bin" ];
    sessionVariables = {
      FLAKE = "$HOME/src/nix/nix-config";
      SHELL = "zsh";
      VISUAL = "nvim";
      EDITOR = "nvim";
    };

    file = {
      "${config.xdg.configHome}/nvim".source =
        lib.custom.relativeToRoot "dotfiles/nvim";
    };
  };

  home.packages = with pkgs; [
    nh
    btop
    eza
    ripgrep
    rm-improved
    dust
    zoxide
    xcp
    unzip
    tmux
    gcc
    zig
    gparted
    gnupg
    dig
    bash
    dolphin
    font-awesome
    tree
    wl-clipboard-rs
    brightnessctl
    age
    nerd-fonts.jetbrains-mono
  ];

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
