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
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager }:
    let
      linux = nixpkgs.legacyPackages.x86_64-linux;
      darwin = nixpkgs.legacyPackages.aarch64-darwin;

      commonModules = [
        home-manager.nixosModules.home-manager
      ];

      # --- Standalone Home Manager (non-NixOS machines) ---------------------
      # Identity comes from the same registry as the NixOS hosts. The plain
      # neovim is dropped from each package list because programs.neovim's
      # wrapped build has the same name and would collide in the profile's
      # buildEnv.
      primaryUser = (builtins.head (import ./users/default.nix).users).userName;
      # Both standalone images need allowUnfree: typescript-vim (programs.neovim)
      # and vscode (programs.vscode) are unfree; NixOS hosts get this from
      # settings/nixpkgs.nix instead.
      ubuntuPkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      macPkgs = import nixpkgs {
        system = "aarch64-darwin";
        config.allowUnfree = true;
      };
      mkHomeModule = { homeDirectory, packageList }: { pkgs, lib, ... }: {
        home = {
          username = primaryUser;
          inherit homeDirectory;
          stateVersion = "26.11"; # first activation is in the 26.11 era
        };
        home.packages = lib.remove pkgs.neovim (import packageList { inherit pkgs; });
      };

    in
    {
      formatter.x86_64-linux = linux.nixpkgs-fmt;

      # # --- Nix profile outputs -------------------------------------------
      # # Ubuntu / Linux
      # packages.x86_64-linux = {
      #   default = makeProfile linux linuxPkgs;
      # };
      # defaultPackage.x86_64-linux = makeProfile linux linuxPkgs;

      # # macOS (Apple Silicon). Intel Macs: add a packages.x86_64-darwin block.
      # packages.aarch64-darwin = {
      #   default = makeProfile darwin darwinPkgs;
      # };
      # defaultPackage.aarch64-darwin = makeProfile darwin darwinPkgs;

      # --- Standalone Home Manager images -----------------------------------
      # For machines that are not NixOS (macOS, Ubuntu).
      #   build:   nix build .#homeConfigurations.jeblas-ubuntu.activationPackage
      #   switch:  home-manager switch --flake .#jeblas-ubuntu   (HM CLI needed)
      homeConfigurations = {
        # macOS (Apple Silicon MacBook Air)
        "${primaryUser}-macos" = home-manager.lib.homeManagerConfiguration {
          pkgs = macPkgs;
          modules = [
            ./settings/programs/base.nix
            (mkHomeModule {
              homeDirectory = "/Users/${primaryUser}";
              packageList = ./packages/darwin.nix;
            })
          ];
        };

        # Ubuntu laptop (x86_64-linux)
        "${primaryUser}-ubuntu" = home-manager.lib.homeManagerConfiguration {
          pkgs = ubuntuPkgs;
          modules = [
            ./settings/programs/base.nix
            ./settings/programs/desktop.nix
            (mkHomeModule {
              homeDirectory = "/home/${primaryUser}";
              packageList = ./packages/linux.nix;
            })
          ];
        };
      };

      nixosConfigurations = {
        tigris = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { nixpkgsSrc = nixpkgs; inherit nixos-hardware; hostName = "Tigris"; };

          modules = commonModules ++ [
            ./machines/tigris
            ./environments/hyprland-desktop.nix
            ./users/base.nix

            # Users from users/default.nix present on this host.
            { hostUsers = [ "jeblas" ]; }

            ./settings/services/printing.nix
            ./settings/services/virtualization.nix
            {
              system.stateVersion = "23.11";
            }
          ];
        };

        rpi2 = nixpkgs.lib.nixosSystem {
          specialArgs = { nixpkgsSrc = nixpkgs; hostName = "rpi2"; };
          system = "armv7l-linux";
          modules = commonModules ++ [
            nixos-hardware.nixosModules.raspberry-pi-2
            ./environments/base.nix
            ./users/base.nix

            # Users from users/default.nix present on this host.
            { hostUsers = [ "jeblas" ]; }
          ];
        };

        rpi5 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { nixpkgsSrc = nixpkgs; hostName = "rpi5"; };
          modules = commonModules ++ [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
            nixos-hardware.nixosModules.raspberry-pi-5
            ./environments/base.nix
            ./users/base.nix

            # Users from users/default.nix present on this host.
            { hostUsers = [ "jeblas" ]; }

            {
              sdImage.compressImage = true;
              boot.initrd.includeDefaultModules = false;

              # Ensure you still have the essentials to boot and see the screen
              boot.initrd.availableKernelModules = [
                "vc4"
                "pcie_brcmstb" # Critical for RPi5 PCIe/USB
                "reset_raspberrypi"
              ];
            }
          ];
        };
      };
    };
}
