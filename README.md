# MacBook Keyboard Fixes on Linux (Debian / Ubuntu / Fedora · Wayland & X11)

Fix swapped or mis-mapped keys on MacBook and MacBook Air keyboards running Linux.
Debugged on a **MacBook Air M4 (macOS host, Debian 13 guest under UTM VM)** and a
**MacBook 9,1 (12-inch, 2016, native Debian)** with the **Turkish Q** layout — the
method generalizes to any layout. The `keyd` fix is verified on the M4; on the
MacBook 9,1 it is **not yet fixed** (same raw key codes, but `keyd` there fails to
parse the config — see the Tested-on table).

Keywords: macbook linux keyboard, debian macbook keyboard fix, wayland keyd,
keyd.rvaiya debian, turkish q linux, xkb macbook, macbook air m4 linux, macbook 9,1 linux.

---

## TL;DR — which method should I use?

| Session | Recommended fix | Why |
| --- | --- | --- |
| **Wayland** (GNOME, KDE, Sway) | **[`keyd`](docs/keyd-setup.md)** | Kernel input layer; works on X11, Wayland, and TTY. |
| **X11** | `keyd` *or* XKB symbols edit | `xmodmap` is session-only. |
| **TTY / text console** | `keyd` | Only method that fixes the console too. |
| Any | ❌  **Do not use `xmodmap` for a permanent fix** | No-op for native Wayland clients. |

**On Debian, if `sudo keyd monitor` says "command not found"** →  see the
[Debian binary rename gotcha](#debian-gotcha-the-keyd--keydrvaiya-rename).

---

## 🔥 Debian gotcha: the `keyd` →  `keyd.rvaiya` rename

On Debian another package also ships a binary named `keyd`. Debian renames the
real one to **`keyd.rvaiya`**. Every guide that says `sudo keyd ...` will fail.

```bash
# Fails on Debian:
sudo keyd monitor
sudo keyd reload

# Works on Debian:
sudo keyd.rvaiya monitor
sudo keyd.rvaiya reload

# Confirm ownership:
dpkg -S "$(command -v keyd.rvaiya)"
```

The **systemd service is still `keyd`**:

```bash
sudo systemctl status keyd
```

---

## 🚑 Quick start (Wayland, recommended)

```bash
# 1. Identify keys
sudo evtest                              # note KEY_* names
keyd.rvaiya list-keys | less             # cross-reference keyd names

# 2. Write config
sudo nano /etc/keyd/default.conf
```

```ini
[ids]
*

[main]
grave = 102nd
102nd = grave
```

```bash
# 3. Apply
sudo keyd.rvaiya reload

# 4. Emergency exit if you break your keyboard:
#    Backspace + Escape + Enter   ->  keyd terminates
```

Full walkthrough: [`docs/keyd-setup.md`](docs/keyd-setup.md).
Turkish Q worked example: [`docs/layouts/turkish-q.md`](docs/layouts/turkish-q.md).

---

## 🧪Tested on

| Hardware | Environment | Display server | Layout | Result |
| --- | --- | --- | --- | --- |
| MacBook Air M4 | macOS host, Debian 13 guest in UTM VM | Wayland | Turkish Q | ✅ fixed — `keyd`, `grave = 102nd` |
| MacBook 9,1 (12-inch, 2016) | Debian 13 (native) | Wayland | Turkish Q | ⚠️ not yet fixed — same `KEY_GRAVE`/`KEY_102ND` codes as the M4, but `keyd` there fails to parse the config |

*Contributions welcome — add a row for your model / distro / layout.*

---

## Documentation

- [`docs/keyd-setup.md`](docs/keyd-setup.md)
- [`docs/wayland-vs-x11.md`](docs/wayland-vs-x11.md)
- [`docs/troubleshooting.md`](docs/troubleshooting.md)
- [`docs/layouts/turkish-q.md`](docs/layouts/turkish-q.md)
- [`configs/`](configs/) · [`scripts/diagnose.sh`](scripts/diagnose.sh)

---

## What did **not** work (and why)

- **`xmodmap`** — runs, and `xev` may show the change, but native Wayland
  clients ignore it. Not a fix.
- **Editing `/usr/share/X11/xkb/symbols/tr` directly** — works under Wayland
  (via `libxkbcommon`) but `xkb-data` updates overwrite it. Use
  `~/.config/xkb/symbols/` instead.
- **`XKBMODEL="macintosh"` in `/etc/default/keyboard`** — sometimes helps,
  compositor-dependent; not reliable alone.
- **[seruman/macos-turkish-keyboard-layout](https://github.com/seruman/macos-turkish-keyboard-layout)**
  — Swift/macOS; reference for the intended mapping, not a Linux fix.

---

## Contributing · License

See [`CONTRIBUTING.md`](CONTRIBUTING.md). Docs: **CC BY-SA 4.0**; scripts/configs: **MIT** — see [`LICENSE`](LICENSE).

## Credits

- [`rvaiya/keyd`](https://github.com/rvaiya/keyd)
- [`yavuzkoroglu/turkishy`](https://github.com/yavuzkoroglu/turkishy)
- [`seruman/macos-turkish-keyboard-layout`](https://github.com/seruman/macos-turkish-keyboard-layout)
