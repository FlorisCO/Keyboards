# Keyboards — QMK Setup Guide

This repository stores QMK keymaps and build configurations for multiple keyboards.
The QMK firmware source is **not** committed here; it is cloned locally and this
repo's keymaps are symlinked (or copied) into it.

## Prerequisites

### Fedora (tested on Fedora 44)

```bash
# System packages
sudo dnf install git python3 python3-pip avr-gcc avr-libc arm-none-eabi-gcc \
    arm-none-eabi-newlib dfu-util dfu-programmer

# QMK CLI
pip3 install --user qmk

# Add ~/.local/bin to PATH if not already present
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### First-time QMK setup

```bash
qmk setup
# QMK will clone the firmware repo to ~/qmk_firmware by default.
# Accept all prompts, or specify a custom path:
#   qmk setup -H ~/path/to/qmk_firmware
```

## Repository layout

```
Keyboards/
├── keyboards/
│   └── <keyboard-name>/         # One directory per keyboard
│       ├── config.json          # Keyboard identity + build target
│       ├── keymap/              # keymap.c (and any extra headers)
│       └── rules.mk             # Optional build overrides
├── scripts/
│   ├── link.sh                  # Symlink keymaps into qmk_firmware
│   └── build-all.sh             # Build all keyboards in one shot
├── .gitignore
└── SETUP.md                     # This file
```

## Adding a new keyboard

1. Create `keyboards/<name>/` following the layout above.
2. Set `keyboard` and `keymap` in `config.json` (see existing keyboards for examples).
3. Run `./scripts/link.sh` to make the keymap visible to QMK.
4. Run `qmk compile -kb <keyboard> -km <keymap>` to verify it builds.

## Building

```bash
# Single keyboard (from anywhere)
qmk compile -kb <keyboard> -km <keymap>

# All keyboards defined in this repo
./scripts/build-all.sh

# Flash directly
qmk flash -kb <keyboard> -km <keymap>
```

## Flashing

Put your keyboard into bootloader mode (usually hold Escape or press the reset
button on the PCB while plugging in), then run `qmk flash`.  
For split keyboards, flash each half separately.

## Keeping QMK up to date

```bash
cd ~/qmk_firmware   # or wherever you cloned it
git pull
qmk setup           # re-runs submodule updates
```
