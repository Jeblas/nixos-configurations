{config, pkgs, ...} :
{
  imports = [
    ./desktop.nix
  ];

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
