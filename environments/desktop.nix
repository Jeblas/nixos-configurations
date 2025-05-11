{ config, pkgs, ... }:
{
  imports = [
    ./base.nix
    ../options/sound.nix
  ];
  # Configure keymap in X11
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";
  };
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.theme = "sugar-dark";

  environment.systemPackages = with pkgs; [
    alacritty
    brave
    obsidian
    spotify
    vscode
    signal-desktop
    # discord
    mpv
    feh
    #fprintd # Fingerprint reader support
    libsForQt5.qt5.qtgraphicaleffects
    sddm-sugar-dark
  ];

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
