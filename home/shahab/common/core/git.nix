{
  lib,
  pkgs,
  config,
  ...
}: {
  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = config.hostSpec.userFullName;
    userEmail = config.hostSpec.email.user;

    extraConfig = {
      gpg = {
        format = "ssh";
      };
      "gpg \"ssh\"" = {
        program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      };
      commit = {
        gpgsign = true;
      };
      user = {
        signingKey = "~/.ssh/id_rihla.pub";
      };
      pull = {
        rebase = true;
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}
