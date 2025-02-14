# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  lib,
  config,
  pkgs,
  ...
}: let
  # Be sure to actually install the font first!
  font = "ComicCodeLigatures";
  username = "shahab";
  email = "shahab@dogar.dev";
  fullName = "Shahab Dogar";
in {
  # You can import other home-manager modules here
  imports = [
    # Custom import to configure font
    (import ./configs/alacritty.nix {
      inherit pkgs config font;
    })

    # Custom import for username and email
    (import ./configs/git.nix {
      inherit pkgs config lib;
      userEmail = email;
      userName = fullName;
    })

    ./configs/firefox.nix
    ./configs/direnv.nix
    ./configs/ssh.nix
    ./configs/nvim.nix
    ./configs/starship.nix
    ./configs/zsh.nix
    ./configs/btop.nix
  ];

  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;

      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  fonts = {
    fontconfig.enable = true;
  };

  home = {
    inherit username;

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.05";
    homeDirectory = "/home/${username}";
    sessionVariables = {
      EDITOR = "nvim";
      NIXOS_OZONE_WL = "1";
    };

    file = {
      "${config.xdg.configHome}/tmux".source = ./dotfiles/tmux;
      "${config.xdg.configHome}/bottom".source = ./dotfiles/bottom;
      "${config.xdg.configHome}/nvim".source = ./dotfiles/nvim;
      "${config.xdg.configHome}/hypr".source = ./dotfiles/hypr;
      "${config.xdg.configHome}/waybar".source = ./dotfiles/waybar;
      "${config.xdg.configHome}/wofi".source = ./dotfiles/wofi;
      "${config.xdg.configHome}/mako".source = ./dotfiles/mako;
    };

    packages = with pkgs; [
      nh
      bottom
      lazygit
      neofetch
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
      kitty
      wofi
      dolphin
      waybar
      font-awesome
      mako
      hyprshot
      hyprlock
      hypridle
      hyprpolkitagent
      pavucontrol
      tree
      wl-clipboard-rs
      brightnessctl
      age
      nerd-fonts.jetbrains-mono
      obsidian
    ];
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
