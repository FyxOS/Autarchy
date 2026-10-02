# Autarchy

**[Omarchy](https://omarchy.org), ported to [FyxOS](https://github.com/FyxOS/FyxOS).**

Omarchy is an opinionated Arch Linux and Hyprland desktop: a curated set of tools,
keybindings, themes, and configuration that installs onto Arch with a script. Autarchy
brings that experience to FyxOS as declarative modules. The whole desktop is one line
of configuration, and it is reproducible and rolled back with the rest of the system.

```nix
{
  imports = [ autarchy.nixosModules.default ];
  autarchy.enable = true;
  autarchy.theme = "tokyo-night";
}
```

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
  possible, so following upstream releases is a routine update.
- **Cached.** Packages come from nixpkgs and `cache.nixos.org`. Nothing heavy is
  rebuilt locally.

## Status

**Planning.** Nothing is usable yet. Autarchy depends on FyxOS, which is itself in the
design phase.

## Relationship to Omarchy

Autarchy is an independent port. It is not affiliated with or endorsed by the Omarchy
project or Basecamp. Credit for the desktop's design belongs to Omarchy and its
contributors.
