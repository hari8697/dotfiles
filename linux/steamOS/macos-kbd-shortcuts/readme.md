I'd structure it like this:

```text
macos-kbd-shortcuts/
├── install.sh
├── bin/
│   └── xremap
└── xremap/
    ├── config.yml
    └── xremap.service
```

## `bin/xremap`

This is simply the **official xremap binary** (`xremap 0.15.9`) that you downloaded. Place it in the `bin/` directory of your macos-kbd-shortcuts and make sure it's executable:

```bash
chmod +x bin/xremap
```

Then on a new machine, all you'll need is:

```bash
git clone <your-macos-kbd-shortcuts>
cd macos-kbd-shortcuts
./install.sh
```

Everything will be installed, the service enabled, and xremap will start automatically on login.
