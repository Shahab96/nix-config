{ config, ... }:

{
  programs = {
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ config.hostSpec.username ];
    };
  };
}
