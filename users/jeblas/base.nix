{ config, lib, pkgs, ... }:
{
  users = {
    mutableUsers = false;
    users.jeblas = {
      isNormalUser = true;
      description = "John";
      home = "/home/jeblas";
      uid = 1000;
      hashedPassword = "$y$j9T$JDnjfZlgeJlPTsuVD91rS0$vEMav2JL1VYdR6qDkOyFwO0RTAZZH7g/nnDXm9FuauC"; # use mkPassword to generate
      extraGroups = [ "wheel" ] ++ lib.optionals config.networking.networkmanager.enable [ "networkmanager" ];

      openssh.authorizedKeys.keys = [
      ];

      packages = with pkgs; [ ];
    };
  };

  # Home Manager is wired up here so every host that defines this user gets a
  # user profile. The environment modules add their own home/*.nix imports.
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";

    users.jeblas = {
      imports = [ ];
    };
  };
}
