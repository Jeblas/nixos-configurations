{ config, pkgs, ... }:
{
  imports = [
    ./base.nix
    ../settings/sound.nix
    # Extends home-manager/base.nix with packages/desktop.nix in
    # home.packages and settings/programs/desktop.nix for the primary user.
    ../home-manager/desktop.nix
  ];

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";
  };
  # services.displayManager.sddm = {
  #   enable = false;
  #   theme = "sddm-astronaut-theme";
  #   extraPackages = with pkgs; [ 
  #     sddm-astronaut 
  #   ];
  #   settings.General.RememberLastSession = false;
  # };

  # services.displayManager.sddm.wayland.enable = false;
  # security.polkit.enable = true;

  # environment.systemPackages = with pkgs; [
    # discord
    # fprintd # Fingerprint reader support
    # sddm-astronaut
  # ];

  # Fixes remote VSCode server and allows for VSCode extensions
  programs.nix-ld.enable = true;

  # TODO
  # programs.dconf.enable = true;
  # services.xserver = {
  #   enable = true;
  #   xkb.options = "eurosign:e";
  #   displayManager.startx.enable = true;
  # };
}
