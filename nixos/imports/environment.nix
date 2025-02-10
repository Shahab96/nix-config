{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
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
  };
}
