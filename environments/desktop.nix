{ config, pkgs, ... }:
{
  imports = [
    ./base.nix
    ../options/sound.nix
  ];

  home-manager.users.jeblas.imports = [
    ../home/desktop.nix
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
    # sddm-astronaut
    opencode
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
