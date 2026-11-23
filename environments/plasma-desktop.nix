{ config, lib, pkgs, ... }:
{
  imports = [
    ./desktop.nix
  ];

  home-manager.users = lib.genAttrs config.hostUsers (_name: {
    imports = [
      ../settings/programs/plasma.nix
    ];
  });

  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    gwenview
    okular
    oxygen
    khelpcenter
    konsole
    kpeople
    plasma-browser-integration
    print-manager
  ];
}