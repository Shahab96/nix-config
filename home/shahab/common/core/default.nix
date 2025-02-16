{
  config,
  lib,
  pkgs,
  hostSpec,
  ...
}:
{
  imports = lib.flatten [
    (map lib.custom.relativeToRoot [
      "modules/common"
      "modules/home-manager"
    ])

    ./alacritty.nix
    ./direnv.nix
    ./git.nix
    ./fonts.nix
  ];

  inherit hostSpec;

  home = {
    username = lib.mkDefault config.hostSpec.username;
    homeDirectory = lib.mkDefault config.hostSpec.home;
    stateVersion = lib.mkDefault "25.05";
    sessionPath = [
      "$HOME/.local/bin"
    ];
    sessionVariables = {
      FLAKE = "$HOME/src/nix/nix-config";
      SHELL = "zsh";
      TERM = "alacritty";
      TERMINAL = "alacritty";
      VISUAL = "nvim";
      EDITOR = "nvim";
    };

    file = {
      "${config.xdg.configHome}/nvim".source = lib.custom.relativeToRoot "dotfiles/nvim";
    };
  };

  home.packages = with pkgs; [
    bottom
    lazygit
    discord
    eza
    ripgrep
    rm-improved
    dust
    gh
    zoxide
    xcp
    unzip
    prismlauncher
    tmux
    lazygit
    gcc
    zig
    protonmail-desktop
    protonvpn-gui
    cloudflare-warp
    kubectl
    gparted
    k9s
    gnupg
    postgresql_17
    dig
    bash
    dolphin
    font-awesome
    tree
    wl-clipboard-rs
    brightnessctl
    age
    nerd-fonts.jetbrains-mono
    obsidian
  ];

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
