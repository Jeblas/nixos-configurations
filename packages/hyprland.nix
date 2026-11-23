# Hyprland session layer: desktop applications plus the compositor's
# helpers. The session binaries (kitty/waybar/wofi/mako/hyprland) are
# installed system-wide by environments/hyprland-desktop.nix; hyprpaper,
# hyprpolkitagent and udiskie are the extras this layer puts in the user
# profile.
{ pkgs, ... }:

let desktop = import ./desktop.nix { inherit pkgs; };
in desktop ++ [
  pkgs.hyprpaper
  pkgs.hyprpolkitagent
  pkgs.udiskie
]