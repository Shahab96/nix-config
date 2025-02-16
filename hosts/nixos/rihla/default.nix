{
  inputs,
  lib,
  ...
}:

{
  imports = lib.flatten [
    #
    # ========= Hardware =========
    #
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd

    #
    # ======== Secure Boot =========
    #
    inputs.lanzaboote.nixosModules.lanzaboote

    #
    # ========= Disk Layout =========
    #
    inputs.disko.nixosModules.disko
    (lib.custom.relativeToRoot "hosts/common/disks/rihla.nix")

    #
    # ========= Required Configs =========
    #
    (map lib.custom.relativeToRoot [
      "hosts/common/core"
    ])

    #
    # ========= Optional Configs =========
    #
    (map (config: lib.custom.relativeToRoot "hosts/common/optional/${config}.nix") [
      "1password"
      "dconf"
      "docker"
      "gaming"
      "hyprland"
      "nix-ld"
      "secure-boot"
      "yubikey"
    ])

    #
    # ========= Optional Services =========
    #
    (map (service: lib.custom.relativeToRoot "hosts/common/optional/services/${service}.nix") [
      "audio"
      "bluetooth"
      "firmware"
      "greetd"
      "openssh"
      "printing"
      "smart-card"
    ])
  ];

  #
  # ========= Host specification =========
  #
  hostSpec = {
    hostName = "rihla";
  };

  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
  };

  boot = {
    loader = {
      # Set this to true on first install. This must be false for secure boot.
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = true;
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };

  security.rtkit.enable = true;

  system.stateVersion = "25.05";
}
