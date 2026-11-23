# User selection + account policy.
#
# The registry of every known user lives in users/default.nix. Each
# nixosConfiguration says which of them exist on that host via the
# `hostUsers` option; this module turns that selection into accounts.
{ config, lib, pkgs, ... }:
let
  registry = (import ./default.nix).users;
  registryNames = map (u: u.userName) registry;
  entryFor = name: builtins.head (builtins.filter (u: u.userName == name) registry);
in
{
  options.hostUsers = lib.mkOption {
    type = lib.types.listOf (lib.types.enum registryNames);
    example = [ "jeblas" ];
    description = ''
      Users from users/default.nix to create on this host. The first entry
      is the primary user (display manager session, machine-specific
      groups, ...).
    '';
  };

  config = {
    assertions = [
      {
        assertion = config.hostUsers != [ ];
        message = "hostUsers must list at least one user from users/default.nix.";
      }
    ];

    users = {
      mutableUsers = false;
      users = lib.genAttrs config.hostUsers (name:
        let u = entryFor name;
        in {
          isNormalUser = true;
          description = u.description;
          home = "/home/${name}";
          uid = u.uid;
          hashedPassword = u.hashedPassword;
          extraGroups = [ "wheel" ] ++ lib.optionals config.networking.networkmanager.enable [ "networkmanager" ];

          openssh.authorizedKeys.keys = [
          ];

          packages = with pkgs; [ ];
        });
    };
  };
}