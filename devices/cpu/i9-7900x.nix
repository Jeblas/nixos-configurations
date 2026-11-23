# The CPU in Tigris: Core i9-7900X (Skylake-X). Model-specific bits go
# here; the generic Intel layer (microcode, kvm-intel, nixos-hardware
# common-cpu-intel-cpu-only) lives in intel.nix next to this file.
{ ... }:
{
  imports = [
    ./intel.nix
  ];
}