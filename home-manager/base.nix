# Home Manager wiring + shared configuration for every host.
#
# This is a NixOS module (imported by environments/base.nix), so the Home
# Manager configuration must be nested under `home-manager.users` (top-level
# `home.*` options don't exist at the NixOS level). Every user the host
# selects in its `hostUsers` option gets the profile below.
#
#   settings/programs/base.nix      - programs.* for every host (pure HM attr set)
#   settings/programs/desktop.nix   - added by home-manager/desktop.nix
#   settings/programs/hyprland.nix  - added by environments/hyprland-desktop.nix
{ config, pkgs, lib, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";

    users = lib.genAttrs config.hostUsers (name: {
      imports = [
        ../settings/programs/base.nix
      ];

      # Keep this in sync with the release you first activated Home Manager with.
      home.stateVersion = "26.11";

      # Git gives ~/.gitconfig precedence over $XDG_CONFIG_HOME/git/config.
      # Keep the legacy path linked to the Home Manager-managed XDG config.
      home.file.".gitconfig".source =
        config.home-manager.users.${name}.xdg.configFile."git/config".source;

      # User-profile packages shared with the flake's dev shells and nix
      # profile outputs (packages/*.nix). home-manager/desktop.nix extends
      # this list with packages/desktop.nix.
      #
      # Drop the plain neovim: programs.neovim (settings/programs/base.nix)
      # already adds a neovim wrapped with the plugin set — same name,
      # different derivation — and two of them collide in the profile's buildEnv.
      home.packages = lib.remove pkgs.neovim
        (import ../packages/common.nix { inherit pkgs; });
    });
  };
}