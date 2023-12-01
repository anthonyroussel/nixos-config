#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix coreutils
set -e

nix key generate-secret --key-name nix-cache.roussel.dev > /etc/nix/nix-cache.roussel.dev.key
nix key convert-secret-to-public < /etc/nix/nix-cache.roussel.dev.key > /etc/nix/nix-cache.roussel.dev.pub
chmod 0600 /etc/nix/nix-cache.roussel.dev.key
