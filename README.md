# Autarchy

**[Omarchy](https://omarchy.org), ported to [FyxOS](https://github.com/FyxOS/FyxOS).**

Omarchy is an opinionated Arch Linux and Hyprland desktop: a curated set of tools,
keybindings, themes, and configuration that installs onto Arch with a script. Autarchy
brings that experience to FyxOS as a flavor. Pick it in the FyxOS installer, and the
whole desktop is reproducible and rolls back with the rest of the system.

## Variants

| Variant | Module | Tracks |
|---|---|---|
| **stable** | `nixosModules.stable` | A pinned Omarchy release, reproduced and scored for fidelity |
| **latest** | `nixosModules.latest` | Omarchy's main branch |

```nix
inputs.flavor = {
  url = "github:FyxOS/Autarchy";
  inputs.nixpkgs.follows = "nixpkgs";
  inputs.fyxos.follows = "fyxos";
};
# modules = [ fyxos.nixosModules.default flavor.nixosModules.stable ... ];
```

## Why it exists: the proof

Autarchy is also FyxOS's reproducibility test. Omarchy is a public reference that FyxOS
does not control. It is a script-driven install that assumes Arch, a standard Linux
layout, and prebuilt binaries, which is the hardest case for NixOS. If both variants
install cleanly from the FyxOS ISO, with nothing built locally, the ecosystem has shown
it can reproduce a curated desktop. Every Omarchy feature that needs a workaround
becomes a FyxOS bug report.

## Why FyxOS

Omarchy assumes a conventional Linux layout, and so do many of the prebuilt apps and
tools it ships with. FyxOS provides that layout (`/usr/lib`, `/lib64/ld-linux…`) on top of
nixpkgs and `cache.nixos.org`. Autarchy can therefore port Omarchy's setup faithfully
instead of working around NixOS for every foreign binary.

## Goals

- **Faithful.** Same apps, keybindings, themes, and look as upstream Omarchy, with
  differences documented.
- **Declarative.** Install scripts become modules. Dotfiles are generated, not copied
  by hand.
- **Tracks upstream.** Themes and configs are derived from Omarchy's sources where
  possible. `stable` moves to a new Omarchy release deliberately; `latest` follows
  main.
- **Follows the FyxOS flavor contract.** It uses the base's nixpkgs (`nixos-unstable`),
  needs nothing built locally, and contains nothing personal.

## Status

**Planning.** Nothing is usable yet. Autarchy follows Atrium in the FyxOS
[roadmap](https://github.com/FyxOS/FyxOS/blob/main/docs/roadmap.md) (Phase 4): `stable`
first, then `latest`.

## Relationship to Omarchy

Autarchy is an independent port. It is not affiliated with or endorsed by the Omarchy
project or Basecamp. Credit for the desktop's design belongs to Omarchy and its
contributors.
