# Common packages plus Linux-specific additions.
# Use this for Ubuntu profiles and NixOS machines.
{ pkgs, ... }:

let common = import ./common.nix { inherit pkgs; };
in common ++ [
  # Linux-only tools go here
]
