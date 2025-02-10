{pkgs, ...}: {
  users = {
    mutableUsers = false;
    users.shahab = {
      shell = pkgs.zsh;

      # Only do this if you have already configured zsh in home manager
      ignoreShellProgramCheck = true;

      isNormalUser = true;
      description = "Shahab Dogar";
      extraGroups = [
        "networkmanager"
        "wheel"
        "input"
        "libvirtd"
      ];
      hashedPassword = "$y$j9T$pvjyL7hL5x2VBarGNTnMl1$mLA2UsWTbfp8Hgp/ug5l8224thi..Mo8.p7ME.tDZ.4";

      openssh.authorizedKeys = {
        keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPBijtTtb6UT5gssWolNGX1rcjAKsdtfz25fZMMnzq4v"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGD/V4jLpuk7uAovkbHFr6uulfBKZmsH+BqmXIR2aYD0"
        ];
      };
    };
  };
}
