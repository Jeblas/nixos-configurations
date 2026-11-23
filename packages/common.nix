# Packages shared across every system (linux, darwin, server, desktop).
{ pkgs, ... }:

with pkgs; [
  bat
  curl
  fd
  fzf
  git
  # git-lfs
  htop
  less
  lsof
  neovim
  nnn
  p7zip
  picocom
  # ripgrep
  simple-http-server
  # starship
  tmux
  tree
  unzip
  wget
  which
  zip
  # zoxide
]