# Storage

Storage profiles install `/etc/fstab`.

Example:

```bash
./install.sh --storage machine
```

The installer:

backs up /etc/fstab
installs the selected profile
reloads systemd
mounts filesystems

Profiles:
storage/
    machine/
        fstab
    deck/

#### Notes

NTFS volumes that were not cleanly shut down may fail to mount.

If SteamOS reports:

volume is dirty and "force" flag is not set

repair the drive in Windows:
```shell
chkdsk X: /f
```

Then verify:
```shell
fsutil dirty query X:
```

Finally perform a complete shutdown:
```shell
shutdown /s /f /t 0
```
