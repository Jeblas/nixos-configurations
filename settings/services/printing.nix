{ pkgs, ... }:
{
  services.printing = {
    enable = true;   # IPP printer support
    drivers = [ pkgs.hplip ];
  };
}
