{ pkgs, config, ... }: {

  networking = {
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

  imports = [ ../../options/wireless.nix ];
}
