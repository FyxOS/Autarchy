# Hyprland - Omarchy

**[Omarchy](https://omarchy.org), ported to [Omnix](https://github.com/Omnix-Linux/Omnix).**

Omarchy is an opinionated Arch Linux and Hyprland desktop: a curated set of tools,
keybindings, themes, and configuration that installs onto Arch with a script. This flavor
brings that experience to Omnix. Pick it in the Omnix installer, and the
whole desktop is reproducible and rolls back with the rest of the system.

Desktop labels follow the [Omnix naming policy](https://github.com/Omnix-Linux/Omnix/blob/main/docs/naming.md).

## Variants

| Variant | Module | Tracks |
|---|---|---|
| **stable** | `nixosModules.stable` | A pinned Omarchy release, reproduced and scored for fidelity |
| **latest** | `nixosModules.latest` | Omarchy's main branch |

```nix
inputs.flavor = {
  url = "github:Omnix-Linux/Autarchy";
  inputs.nixpkgs.follows = "nixpkgs";
  inputs.omnix.follows = "omnix";
};
# modules = [ omnix.nixosModules.default flavor.nixosModules.stable ... ];
```

## Why it exists: the proof

This port is also Omnix's reproducibility test. Omarchy is a public reference that Omnix
does not control. It is a script-driven install that assumes Arch, a standard Linux
layout, and prebuilt binaries, which is the hardest case for NixOS. If both variants
install cleanly from the Omnix ISO, with nothing built locally, the ecosystem has shown
it can reproduce a curated desktop. Every Omarchy feature that needs a workaround
becomes an Omnix bug report.

## Why Omnix

Omarchy assumes a conventional Linux layout, and so do many of the prebuilt apps and
tools it ships with. Omnix provides that layout (`/usr/lib`, `/lib64/ld-linux…`) on top of
nixpkgs and `cache.nixos.org`. This flavor can therefore reproduce Omarchy's setup faithfully
instead of working around NixOS for every foreign binary.

## Goals

- **Faithful.** Same apps, keybindings, themes, and look as upstream Omarchy, with
  differences documented.
- **Declarative.** Install scripts become modules. Dotfiles are generated, not copied
  by hand.
- **Tracks upstream.** Themes and configs are derived from Omarchy's sources where
  possible. `stable` moves to a new Omarchy release deliberately; `latest` follows
  main.
- **Follows the Omnix flavor contract.** It uses the base's nixpkgs (`nixos-unstable`),
  needs nothing built locally, and contains nothing personal.

## Status

**First version.** It is built from Omarchy's own pinned source (`stable` =
v4.0.4, `latest` = `quattro`):

- **Omarchy's defaults** (`default/`, `themes/`, `bin/`) are read-only in the
  store at `$OMARCHY_PATH`, where Omarchy's Lua config looks for them.
- **Each user's `~/.config`** is seeded once from Omarchy's `config/` templates,
  as Omarchy's installer does.
- **Hyprland 0.56 runs Omarchy's Lua config unmodified,** under uwsm.
- **Packages:** 131 of Omarchy's 147 base packages are mapped to nixpkgs
  (`modules/packages.nix`).

`nix flake check` boots the `stable` variant to a Hyprland session running
Omarchy's bar and first-run notifications.

Known gaps:
- Arch-only pieces are not ported: `yay`, `pacman-contrib`, `expac`, and
  Omarchy's own apps (`omacalc`, `omacut`, `omawrite`, `omarchy-nvim`, `aether`,
  `herdr`, `tensaku`, ...).
- Omarchy's "Update System" action is pacman-based. On Omnix, updating is
  `nix flake update` plus a rebuild.
- The first-boot theme does not set a wallpaper yet.

## Relationship to Omarchy

This is an independent port of Omarchy. It is not affiliated with or endorsed by the Omarchy
project or Basecamp. Credit for the desktop's design belongs to Omarchy and its
contributors.
