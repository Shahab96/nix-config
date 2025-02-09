# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  lib,
  inputs,
  pkgs,
  hostname,
  ...
}: let
  secretspath = builtins.toString inputs.nix-secrets;
in {
  # Bootloader.
  boot = {
    loader = {
      # Set this to true on first install. This must be false for secure boot.
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = true;
    };

    # initrd.postResumeCommands = lib.mkAfter ''
    #   mkdir /btrfs_tmp
    #   mount /dev/luks_vg/root /btrfs_tmp
    #   if [[ -e /btrfs_tmp/root ]]; then
    #       mkdir -p /btrfs_tmp/old_roots
    #       timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
    #       mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    #   fi
    #
    #   delete_subvolume_recursively() {
    #       IFS=$'\n'
    #       for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
    #           delete_subvolume_recursively "/btrfs_tmp/$i"
    #       done
    #       btrfs subvolume delete "$1"
    #   }
    #
    #   for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
    #       delete_subvolume_recursively "$i"
    #   done
    #
    #   btrfs subvolume create /btrfs_tmp/root
    #   umount /btrfs_tmp
    # '';

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };

  networking.hostName = hostname; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Karachi";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ur_PK";
    LC_IDENTIFICATION = "ur_PK";
    LC_MEASUREMENT = "ur_PK";
    LC_MONETARY = "ur_PK";
    LC_NAME = "ur_PK";
    LC_NUMERIC = "ur_PK";
    LC_PAPER = "ur_PK";
    LC_TELEPHONE = "ur_PK";
    LC_TIME = "ur_PK";
  };

  # Enable flakes
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    experimental-features = ["nix-command" "flakes"];
  };

  # Enable greetd and tuigreet
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time --cmd ${pkgs.hyprland}/bin/Hyprland";
        user = "greeter";
      };
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable blueman
  services.blueman.enable = true;

  # Enable smart card services
  services.pcscd.enable = true;

  # Framework firmware updating
  services.fwupd.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.udev.extraRules = ''
    ACTION=="remove",\
    ENV{ID_BUS}=="usb",\
    ENV{ID_MODEL_ID}=="0407",\
    ENV{ID_VENDOR_ID}=="1050",\
    ENV{ID_VENDOR}=="Yubico",\
    RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
  '';

  hardware = {
    # Bluetooth.
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;

    graphics = {
      enable = true;
      extraPackages = with pkgs; [amdvlk];
    };
  };

  security.rtkit.enable = true;

  security.pam.yubico = {
    enable = true;
    mode = "challenge-response";
    id = ["24353659"];
  };

  users.mutableUsers = false;
  users.users.shahab = {
    shell = pkgs.zsh;

    # Only do this if you have already configured zsh in home manager
    ignoreShellProgramCheck = true;

    isNormalUser = true;
    description = "Shahab Dogar";
    extraGroups = ["networkmanager" "wheel" "input" "libvirtd"];
    initialPassword = "tempPass";
    hashedPasswordFile = config.sops.secrets."user_passwords/shahab".path;
  };

  sops = {
    defaultSopsFile = "${secretspath}/secrets.yaml";
    age = {
      sshKeyPaths = ["/home/shahab/.ssh/id_ed25519"];
      keyFile = "/home/shahab/.config/sops/age/keys.txt";
      generateKey = true;
    };
    secrets = {
      "user_passwords/shahab" = {
        neededForUsers = true;
      };
    };
  };

  # Allow unfree packages
  nixpkgs = {
    config = {
      pulseaudio = false;
      allowUnfree = true;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    pciutils
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    win-virtio
    win-spice
    sops
    sbctl # Secure boot
    yubikey-manager

    # Gaming stuff
    mangohud
    protonup-qt
  ];

  environment.persistence."/persistent" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/sbctl"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id"
    ];
    users.shahab = {
      directories = [
        "Downloads"
        "Knowledge"
        "nix-config"
        "nix-secrets"
        ".config"
        ".local"
        ".1password"
        ".steam"
        ".mozilla"
        { directory = ".ssh"; mode = "0700"; }
      ];
    };
  };

  # Enable steam for gaming
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = ["shahab"];
  };

  programs.dconf.enable = true;

  # Hyprland
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  programs.nix-ld = {
    enable = true;
  };

  virtualisation = {
    podman = {
      enable = true;
      dockerSocket.enable = true;
      dockerCompat = true;

      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };

    containers = {
      registries = {
        search = ["docker.io"];
      };
    };

    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;

        ovmf = {
          enable = true;
          packages = with pkgs; [OVMFFull.fd];
        };
      };
    };

    spiceUSBRedirection.enable = true;
  };

  services.spice-vdagentd.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
