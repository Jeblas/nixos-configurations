# Linux server — common + linux + server tools.
{ pkgs, ... }:

let linux = import ./linux.nix { inherit pkgs; };
in linux ++ [
  pkgs.htop
  pkgs.vim
  pkgs.tmux
  pkgs.ncdu
]
