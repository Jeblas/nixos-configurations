{ config, ... }:
{
  boot.binfmt.emulatedSystems = [ "aarch64-linux" "armv7l-linux" ];
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  # The primary user: first entry of the host's hostUsers.
  users.users.${builtins.head config.hostUsers}.extraGroups = [ "libvirtd" ];
}
