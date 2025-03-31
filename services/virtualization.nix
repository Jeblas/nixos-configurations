{config, ...} : {
  boot.binfmt.emulatedSystems = [ "aarch64-linux" "armv7l-linux" ];
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  users.users.jeblas.extraGroups = [ "libvirtd" ];
}
