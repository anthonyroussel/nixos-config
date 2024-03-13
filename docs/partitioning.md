# Partitioning SSD

## Change SATA Operation in Firmware Setup

⚠️ Disable Intel® Rapid Storage Technology (aka. Fake RAID) in UEFI Firmware Setup, and select **AHCI** instead.

## Create the partition table

```bash
# parted /dev/nvme0n1 -- mklabel gpt
```

## Create the EFI System Partition (ESP)

```bash
# parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 512MiB
# parted /dev/nvme0n1 -- set 1 esp on
```

## Create the LVM partition

```bash
# parted /dev/nvme0n1 -- mkpart primary 512MiB 100%
# parted /dev/nvme0n1 -- set 2 lvm on
```

## Format the EFI System Partition (ESP)

```bash
# mkfs.fat -F 32 -n boot /dev/nvme0n1p1
```

## Crypt the LVM partition

```console
cryptsetup luksFormat /dev/nvme0n1p2
```

Then generate the recovery key for the LUKS partition (just in case of lost password):

```console
systemd-cryptenroll --recovery-key /dev/nvme0n1p2
```

:warning: Store the recovery key in a safe location.

Same for the LUKS header:

```console
cryptsetup luksHeaderBackup /dev/nvme0n1p2 --header-backup-file luks-header-nvme0n1p2.bin
```

Then open the LUKS-encrypted LVM partition with:

```console
cryptsetup open /dev/nvme0n1p2 pool
```

## Create the LVM Physical Volume and Virtual Group

```bash
# pvcreate /dev/nvme0n1p2
# vgcreate pool /dev/nvme0n1p2
```

## Create the NixOS Logical Volume

```bash
# lvcreate -L 50G -n nixos pool
# mkfs.btrfs /dev/pool/nixos
# btrfs subvolume create /home
# btrfs subvolume create /nix
```

## Mounting target filesystem

```bash
mkdir -p /mnt/nixos
mount /dev/pool/nixos /mnt/nixos
```

## Mounting Nix secrets

Refer to [my Nix secrets repository](https://github.com/anthonyroussel/nix-secrets)

## Installing NixOS

```console
nixos-generate-config --root /mnt/nixos
nixos-install --root /mnt/nixos --flake github:anthonyroussel/nixos-config#rsl-xps
```

## Create the home-partition

```bash
# lvcreate -L 30G -n home-aroussel pool
# mkfs.btrfs /dev/mapper/home-aroussel
# mkdir -p /home/aroussel
# mount /dev/mapper/home-aroussel /home/aroussel
# btrfs subvolume create /home/aroussel
# umount /home/aroussel
```
