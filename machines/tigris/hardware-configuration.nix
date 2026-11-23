# Generated core of the machine config, kept as its own file per the
# nixos-generate-config convention. default.nix composes it with the
# boot/filesystems/intel/networking splits and the nixos-hardware modules.
{ lib, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}