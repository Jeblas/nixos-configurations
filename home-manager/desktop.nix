# Desktop layer: builds on home-manager/base.nix (Home Manager wiring +
# packages/common.nix in home.packages) with the desktop package list and
# the user-level desktop configuration. Applies to every user the host
# selects in `hostUsers`.
#
# Imported by environments/desktop.nix, which environments/hyprland-desktop.nix
# and environments/plasma-desktop.nix build on.
{ config, pkgs, lib, ... }:
{
  imports = [
    ./base.nix
  ];

  home-manager.users = lib.genAttrs config.hostUsers (_name: {
    imports = [
      ../settings/programs/desktop.nix
    ];

    # Extends home-manager/base.nix's home.packages (packages/common.nix)
    # with the desktop application list (alacritty, brave, obsidian, ...).
    # The module system concatenates both definitions.
    #
    # Plain neovim is dropped for the same reason as in base.nix:
    # programs.neovim's wrapped neovim would collide with it in buildEnv.
    home.packages = lib.remove pkgs.neovim
      (import ../packages/desktop.nix { inherit pkgs; });
  });
}