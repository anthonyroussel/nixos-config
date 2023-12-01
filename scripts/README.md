# rsl-cloud

## Bootstrap image

nix build '.#rsl-cloud'

## Remote upgrade

```bash
sudo nix build '.#rsl-cloud'
sudo nix store sign --recursive '.#rsl-cloud' -k /var/lib/sops-nix/rsl-xps.roussel.dev.key
```

```shell
nixos-rebuild --target-host rsl-cloud --use-remote-sudo --flake ".#rsl-cloud" switch
```

nix build '.#nixosConfigurations.rsl-cloud.config.system.build.toplevel'
sudo nix store sign '.#nixosConfigurations.rsl-cloud.config.system.build.toplevel' -k /etc/nix/nix-cache.roussel.dev.key
nix copy '.#nixosConfigurations.rsl-cloud.config.system.build.toplevel' --to ssh://rsl-cloud
