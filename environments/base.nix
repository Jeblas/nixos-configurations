{ config, pkgs, lib, ... }:
{
  imports = [
    ../options/networking.nix
    # TODO ../options/gpg.nix
    ../options/localization.nix
    ../options/nix.nix
    ../options/nixpkgs.nix
    ../services/ssh.nix
    ../services/avahi.nix
    ../services/podman.nix
  ];

  home-manager.users.jeblas.imports = [
    ../home/base.nix
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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    htop
    wget
    curl
    nnn
    tree
    simple-http-server
    p7zip
    unzip
    zip
    podman-compose
    git
    picocom
  ];

  # neovim and tmux configuration now lives in home/base.nix so it is managed
  # by Home Manager instead of the system profile.
}
