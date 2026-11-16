# Turkish Q on a MacBook — `"` and `<` swapped

## Symptom

With the Turkish Q layout on Debian, the `"` and `<` keys are reversed:

- The key that should give `"` outputs `<`
- The key that should give `<` outputs `"`

Reproduced on:
- **MacBook Air M4** — Debian in a **UTM VM** (Wayland)
- **MacBook 9,1 (12-inch, 2016)** — **native Debian** (Wayland) — `grave = 102nd` swap does **not** fix it there

## Root cause

Apple's physical Turkish Q layout places these two symbols on different
physical keys than the PC/ISO assumptions in Debian's XKB driver. On MacBook
ISO keyboards the relevant physical keys surface as `TLDE`/`grave` and
`LSGT`/`102nd`, and Debian's default mapping assigns quote and less-than to
the opposite keys from Apple's intent.

## Fix (recommended: `keyd`, works on Wayland)

Identify key names **on the actual machine** with `evtest` (see
[`../keyd-setup.md`](../keyd-setup.md)), then:

```ini
# /etc/keyd/default.conf
[ids]
*

[main]
grave = 102nd
102nd = grave
```

```bash
sudo keyd.rvaiya reload
```

> Do **not** copy key names blindly from another machine or from a VM — run
> `evtest` on the system you are fixing. Verified here: the `grave = 102nd` swap
> works on a MacBook Air **M4** (UTM VM) only — it does **not** fix a MacBook 9,1.

## Why not `xmodmap`?

No-op for native Wayland clients. See [`../wayland-vs-x11.md`](../wayland-vs-x11.md).

## Why not edit `/usr/share/X11/xkb/symbols/tr`?

Works under Wayland, but `xkb-data` updates overwrite it. Use
`~/.config/xkb/symbols/` if you prefer XKB.

## References

- [`rvaiya/keyd`](https://github.com/rvaiya/keyd)
- [`yavuzkoroglu/turkishy`](https://github.com/yavuzkoroglu/turkishy)
- [`seruman/macos-turkish-keyboard-layout`](https://github.com/seruman/macos-turkish-keyboard-layout)
