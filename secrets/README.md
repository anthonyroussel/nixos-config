# Edit the Sops secret file

```bash
GNUPGHOME=/var/lib/sops sudo -E sops rsl-xps.yaml
```

GnuPG keyring is located in `/var/lib/sops` and is readable only by the `root` user.
