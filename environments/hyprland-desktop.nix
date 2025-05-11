{config, pkgs, ...} :
{
  imports = [
    ./desktop.nix
  ];

  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;
  environment.systemPackages = [
    pkgs.kitty # required for the default Hyprland config
    pkgs.wofi
    pkgs.waybar
    pkgs.hyprpaper
    pkgs.hyprpolkitagent
    pkgs.mako
    pkgs.udiskie
  ];
  services.udisks2.enable = true;
  services.udisks2.mountOnMedia = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
