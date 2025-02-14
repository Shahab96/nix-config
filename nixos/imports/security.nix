{...}: {
  security = {
    rtkit.enable = true;
    pam = {
      u2f = {
        enable = true;
        settings = {
          cue = true;
        };
      };
      services = {
        sudo.u2fAuth = true;
        login.u2fAuth = true;
      };
    };
  };
}
