nixos-rebuild switch --flake .#tigris
# sudo nix --extra-experimental-features nix-command --extra-experimental-features flakes build .#nixosConfigurations.tigris.config.system.build.toplevel -L -j22
# sudo ./result/bin/switch-to-configuration switch