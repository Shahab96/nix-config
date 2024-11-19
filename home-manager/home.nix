# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  # Be sure to actually install the font first!
  font = "ComicCodeLigatures";
  username = "shahab";
  email = "shahab@dogar.dev";
  fullName = "Shahab Dogar";
in
{
  # You can import other home-manager modules here
  imports = [
    # Custom import to configure font
    (import ./configs/alacritty.nix { inherit pkgs config; font = font; })

    # Custom import for username and email
    (import ./configs/git.nix { inherit pkgs config lib; userEmail = email; userName = fullName; })

    ./configs/firefox.nix
    ./configs/direnv.nix
    ./configs/ssh.nix
    ./configs/nvim.nix
    ./configs/starship.nix
    ./configs/zsh.nix
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

  fonts.fontconfig.enable = true;

  home = {
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.05";

    username = username;
    homeDirectory = "/home/${username}";
    sessionVariables = {
      EDITOR = "nvim";
      NIXOS_OZONE_WL = "1";
    };

    file = {
      "${config.xdg.configHome}/tmux".source = ./dotfiles/tmux;
      "${config.xdg.configHome}/bottom".source = ./dotfiles/bottom;
      "${config.xdg.configHome}/nvim".source = ./dotfiles/nvim;
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

      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
