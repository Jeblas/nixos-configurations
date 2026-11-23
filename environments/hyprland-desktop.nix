{ config, pkgs, ... }:
{
  imports = [
    ./desktop.nix
    # Extends home-manager/desktop.nix with packages/hyprland.nix and
    # settings/programs/hyprland.nix.
    ../home-manager/hyprland-desktop.nix
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.displayManager.sddm.enable = false;
  services.greetd = {
    enable = true;
    # package = pkgs.tuigreet;
    useTextGreeter = true;
    settings = {
      default_session = {
        # command = "${pkgs.greetd}/bin/agreety --cmd ${pkgs.hyprland}/bin/start-hyprland";
        # command = "${pkgs.tuigreet}/bin/tuigreet --cmd ${pkgs.hyprland}/bin/start-hyprland";
        command = "${pkgs.hyprland}/bin/start-hyprland";
        # The primary user: first entry of the host's hostUsers.
        user = builtins.head config.hostUsers;
      };
    };
  };

  environment.systemPackages = [
    pkgs.kitty # alternative terminal; alacritty is $terminal in hyprland.conf
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
