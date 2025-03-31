{
  description = "NixOS system configurations for a variety of machines";

  nixConfig = {
    extra-substituters = [
      # "https://smos.cachix.org"
      # "https://feedback.cachix.org"
    ];
    extra-trusted-public-keys = [
      # "smos.cachix.org-1:YOs/tLEliRoyhx7PnNw36cw2Zvbw5R0ASZaUlpUv+yM="
      # "feedback.cachix.org-1:8PNDEJ4GTCbsFUwxVWE/ulyoBMDqqL23JA44yB0j1jI="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = { self, nixpkgs, nixos-hardware} :
  let
    # 
  in
  {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    nixosConfigurations = {
      tigris = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { nixpkgsSrc = nixpkgs; hostName = "Tigris"; };

        modules = [
          nixos-hardware.nixosModules.common-pc
          nixos-hardware.nixosModules.common-cpu-intel-cpu-only # Core i9-7900X, Skylake-X
          nixos-hardware.nixosModules.common-pc-ssd
          nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
          ./machines/tigris/hardware-configuration.nix
          ./environments/plasma-desktop.nix
          ./users/jeblas/base.nix
          ./services/printing.nix
          { system.stateVersion = "23.11"; }
        ];


      };

      rpi2 = nixpkgs.lib.nixosSystem {
        specialArgs = { nixpkgsSrc = nixpkgs; hostName = "rpi2"; };
        system = "armv7l-hf-multiplatform";
        modules = [
          nixos-hardware.nixosModules.raspberry-pi-2
        ];
      };

      rpi5 = nixpkgs.lib.nixosSystem {
        specialArgs = { nixpkgsSrc = nixpkgs; hostName = "rpi5"; };
        system = "aarch64-linux";
        modules = [
          nixos-hardware.nixosModules.raspberry-pi-5
        ];
      };
    };
  };
}
