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

  home = {
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.05";

    username = username;
    homeDirectory = "/home/${username}";
    sessionVariables = {
      EDITOR = "nvim";
      NIXOS_OZONE_WL = "1";
    };

    packages = with pkgs; [
      neofetch
      mission-center
      discord
      eza
      ripgrep
      rm-improved
      dust
      firefox
      gh
    ];
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
