{ config, pkgs, lib, ... }:
{
  imports = [
    ../settings/networking.nix
    # TODO ../settings/gpg.nix
    ../settings/localization.nix
    ../settings/nix.nix
    ../settings/nixpkgs.nix
    ../settings/services/ssh.nix
    ../settings/services/avahi.nix
    ../settings/services/podman.nix
    ../home-manager/base.nix
  ];

  #TODO  services.tailscale.enable = true;

  programs.bash.promptInit = ''
    PS1="\[\e[36m\]\u@\H\[\e[m\] | 📅 \d ⌚️ \A\n[\w]\$ "
  '';

  fonts = {
    packages = with pkgs; [
      nerd-fonts.hack
      roboto
      roboto-mono
      noto-fonts-color-emoji
    ];
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      antialias = true;
      defaultFonts = {
        serif = [ "Hack" ];
        sansSerif = [ "Hack" ];
        emoji = [ "Noto Color Emoji" "Noto Emoji" ];
      };
      hinting = {
        enable = true;
        style = "medium";
      };
      subpixel = {
        rgba = "vrgb";
        lcdfilter = "none";
      };
    };
  };

    environment.systemPackages = with pkgs; [
      podman-compose
      # lsusb
    ];
}
