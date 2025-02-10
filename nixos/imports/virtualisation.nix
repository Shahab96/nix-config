{pkgs, ...}: {
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
}
