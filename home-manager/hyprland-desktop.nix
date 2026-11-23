# Hyprland desktop layer: builds on home-manager/desktop.nix (Home Manager
# wiring + packages/common.nix + packages/desktop.nix in home.packages) with
# the Hyprland session helpers and the user-level Hyprland configuration.
# Applies to every user the host selects in `hostUsers`.
#
# Imported by environments/hyprland-desktop.nix.
{ config, pkgs, lib, ... }:
{
  imports = [
    ./desktop.nix
  ];

  home-manager.users = lib.genAttrs config.hostUsers (_name: {
    imports = [
      ../settings/programs/hyprland.nix
    ];

    # Extends desktop.nix's home.packages with packages/hyprland.nix
    # (hyprpaper, hyprpolkitagent, udiskie). Plain neovim is dropped like in
    # base.nix: programs.neovim's wrapped neovim would collide with it.
    home.packages = lib.remove pkgs.neovim
      (import ../packages/hyprland.nix { inherit pkgs; });
  });
}