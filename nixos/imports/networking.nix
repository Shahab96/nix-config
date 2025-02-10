{hostName, ...}: {
  networking = {
    inherit hostName;
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [22];
  };
}
