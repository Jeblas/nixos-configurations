{ pkgs, config, lib, ... }: {

  networking = {
    # DHCP for any interface without an explicit declaration below (moved
    # from hardware-configuration.nix, where nixos-generate-config put it).
    useDHCP = lib.mkDefault true;

    interfaces = {
      wlp3s0.useDHCP = true;
      eno1 = {
        useDHCP = true;
        wakeOnLan.enable = true;
      };
    };
    wireless = {
      interfaces = [ "wlp3s0" ];
    };
  };

  imports = [ ../../settings/wireless.nix ];
}
