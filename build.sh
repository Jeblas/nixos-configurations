sudo nixos-rebuild switch --flake .#tigris -L

# Switch if flakes not enabled
# nix --extra-experimental-features nix-command --extra-experimental-features flakes flake update

# Manually build and switch
# sudo nix --extra-experimental-features nix-command --extra-experimental-features flakes build .#nixosConfigurations.tigris.config.system.build.toplevel -L -j22
# sudo ./result/bin/switch-to-configuration switch
