{ config, pkgs, lib, ... }:
{
  # Plasma itself is configured system-wide. These are user-level settings for
  # Qt apps in the Plasma environment.
  qt = {
    enable = true;
    platformTheme.name = "kde";
    style.name = "breeze";
  };
}
