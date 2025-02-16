{
  lib,
  ...
}:
{
  imports = lib.flatten [
    #
    # ========== Required Configs ==========
    #
    ./common/core

    #
    # ========== Host-specific Optional Configs ==========
    #
    (map (config: "${builtins.toString ./.}/common/optional/${config}.nix") [
      "btop"
      "firefox"
      "hyprland"
      "misc-packages"
      "nvim"
      "ssh"
      "starship"
      "tmux"
      "zsh"
    ])
  ];

  services.yubikey-touch-detector.enable = true;

  home = {
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "25.05";
    sessionVariables = {
      EDITOR = "nvim";
      NIXOS_OZONE_WL = "1";
    };
  };
}
