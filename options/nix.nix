{ nixpkgsSrc, pkgs, ... }:
{
  nix = {
    package = pkgs.nixVersions.latest;
    # package = pkgs.nixVersions.nix_2_18;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    settings = {
      trusted-users = [ "root" "@wheel" "jeblas" ];
      sandbox = true;
      trusted-substituters = [
        "https://split.cachix.org"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=
      ];
    };

    registry.nixpkgs.flake = nixpkgsSrc; # pin nix flake registry, to avoid downloading the latest all the time
    nixPath = [ "nixpkgs=${nixpkgsSrc}" ];
  };
}
