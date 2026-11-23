# Tigris composition root: every machine-specific file plus the matching
# nixos-hardware modules. flake.nix imports this as ./machines/tigris
# (directory → default.nix).
#
# `nixos-hardware` is the flake input, handed to modules via specialArgs.
{ nixos-hardware, ... }:
{
  imports = [
    # nixos-hardware shared modules for this box. CPU/GPU-specific modules
    # come in through devices/cpu/intel.nix and devices/gpu/nvidia.nix.
    nixos-hardware.nixosModules.common-pc
    nixos-hardware.nixosModules.common-pc-ssd

    # Machine files (split from the original nixos-generate-config output)
    ./hardware-configuration.nix # not-detected.nix + nixpkgs.hostPlatform
    ./networking.nix
    ../../devices/bluetooth.nix
    ../../devices/gpu/nvidia.nix
    ./boot.nix
    ./filesystems.nix
    ../../devices/cpu/i9-7900x.nix
  ];
}