# Common packages plus macOS-specific additions.
{ pkgs, ... }:

let common = import ./common.nix { inherit pkgs; };
in common ++ [
  # GNU equivalents that macOS lacks by default
  pkgs.coreutils
  pkgs.gnumake
]
