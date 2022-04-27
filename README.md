![nixos-config](https://socialify.git.ci/anthonyroussel/nixos-config/image?description=1&font=KoHo&forks=1&issues=1&language=1&name=1&owner=1&pattern=Circuit%20Board&pulls=1&stargazers=1&theme=Dark)

# Deploy

```
sudo nixos-rebuild --flake ".#xps" switch
```

# Current Hosts

| Configuration                       | Type      | Location    | Description                  |
| ----------------------------------- | --------- | ----------- | ---------------------------- |
| [xps](./machines/xps)               | Desktop   | local       | Dell XPS 15 9560 laptop      |

# Sources

See https://github.com/NixOS/nixos-hardware repository.

This repository contains a collection of NixOS modules covering hardware quirks.
