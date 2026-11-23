# Generic Intel CPU layer: microcode, kvm-intel, and the matching
# nixos-hardware module. Machine-specific CPU files (e.g.
# machines/tigris/i9-7900x.nix) import this and add model-specific bits.
#
# Requires `nixos-hardware` in specialArgs (see flake.nix).
{ config, lib, nixos-hardware, ... }:
{
  imports = [
    nixos-hardware.nixosModules.common-cpu-intel-cpu-only
  ];

  boot.kernelModules = [ "kvm-intel" ];
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}