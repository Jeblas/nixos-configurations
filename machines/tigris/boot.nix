# Bootloader, kernel choice and the storage/input drivers initrd needs.
# Split from the nixos-generate-config output in hardware-configuration.nix.
{ pkgs, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ]; # kvm-intel is declared in intel.nix
  boot.extraModulePackages = [ ];
}