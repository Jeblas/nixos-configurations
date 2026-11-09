{ lib, ... }:
{
  hardware.raspberry-pi.configtxt.settings.pi5.enable_uart = lib.mkForce true;
  boot.kernelParams = [ "console=ttyAMA10,115200n8" ];
}