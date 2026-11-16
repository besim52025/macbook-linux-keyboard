# Wayland vs X11 — why `xmodmap` is not a fix

| Tool | Wayland | X11 | TTY | Persistent |
| --- | --- | --- | --- | --- |
| `keyd` / `xremap` | ✅  | ✅  | ✅  | ✅  |
| XKB edit in `~/.config/xkb/` | ✅  | ✅  | ❌  | ✅  |
| `setxkbmap` / `XKBMODEL="macintosh"` | ⚠ ️  | ✅  | ❌  | ✅  |
| `xmodmap` | ❌  | ✅  | ❌  | ❌  |

## Why `xmodmap` fails on Wayland

`xmodmap` talks to an **X server**. Wayland compositors (Mutter, KWin, Sway)
do not use the X server for native input; they read from `libinput` /
`libxkbcommon`. `xmodmap` "runs," and an XWayland client like `xev` may even
show the change — but every native Wayland app ignores it.

Check your session:

```bash
echo $XDG_SESSION_TYPE      # prints "wayland" or "x11"
```

If it prints `wayland`, skip every `xmodmap` tutorial.

## What the XKB files *do* affect under Wayland

Compositors use `libxkbcommon`, so **XKB symbols edits do work under Wayland**.
The trap is *where* you edit:

- `/usr/share/X11/xkb/symbols/tr` →  works, but `xkb-data` updates overwrite it.
- `~/.config/xkb/symbols/<name>` →  survives updates; point your compositor at it.

XKB edits still don't fix the TTY. Prefer `keyd`.

## `/etc/default/keyboard` and `XKBMODEL`

`XKBMODEL="macintosh"` *can* fix some mappings on some compositors — not
reliable across GNOME/KDE/Sway versions. Try after `keyd`, not instead.
