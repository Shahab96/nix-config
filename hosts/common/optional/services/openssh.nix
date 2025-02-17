{ config, ... }:
let sshPort = config.hostSpec.networking.ports.tcp.ssh;
in {
  services.openssh = {
    enable = true;
    ports = [ sshPort ];
  };

  networking.firewall.allowedTCPPorts = [ sshPort ];
}
