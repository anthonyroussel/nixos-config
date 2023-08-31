# Partitioning SSD

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

## Create the LVM Physical Volume and Virtual Group

```bash
# pvcreate /dev/nvme0n1p2
# vgcreate pool /dev/nvme0n1p2
```

## Create the NixOS Logical Volume

```bash
# lvcreate -L 50G -n nixos-23_05 pool
# mkfs.btrfs /dev/pool/nixos-23_05
# btrfs subvolume create /home
# btrfs subvolume create /nix
```

## Installing

```bash
mkdir -p /mnt/nixos-23_05
mount /dev/pool/nixos-23_05 /mnt/nixos-23_05
nixos-generate-config --root /mnt/nixos-23_05
```

## Create the LUKS encrypted home-partition

```bash
# lvcreate -L 30G -n home-aroussel pool
# crypsetup luksFormat /dev/pool/home-aroussel
# crypsetup luksOpen /dev/pool/home-aroussel home-aroussel
# mkfs.btrfs /dev/mapper/home-aroussel
# mkdir -p /home/aroussel
# mount /dev/mapper/home-aroussel /home/aroussel
# btrfs subvolume create /home/aroussel
# umount /home/aroussel
# crypsetup luksClose home-aroussel
```
