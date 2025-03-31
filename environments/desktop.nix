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

  environment.systemPackages = with pkgs; [
    alacritty
    brave
    obsidian
    spotify
    vscode
    signal-desktop
    # discord
    mpv
    #fprintd # Fingerprint reader support
  ];

  # Fixes remote VSCode server and allows for VSCode extensions
  programs.nix-ld.enable = true;

  nixpkgs.config.permittedInsecurePackages = [
    "electron-24.8.6"
    "electron-25.9.0"
  ];

  # TODO
  # programs.dconf.enable = true;
  # services.xserver = {
  #   enable = true;
  #   xkb.options = "eurosign:e";
  #   displayManager.startx.enable = true;
  # };
}
