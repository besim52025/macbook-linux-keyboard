# Troubleshooting

| Symptom | Cause | Fix |
| --- | --- | --- |
| `sudo keyd monitor` →  command not found (Debian) | Binary renamed | Use `sudo keyd.rvaiya monitor` |
| `xmodmap` runs, keys unchanged in apps | You are on Wayland | Use `keyd` — see [wayland-vs-x11](wayland-vs-x11.md) |
| XKB edit reverted after update | `xkb-data` overwrote `/usr/share/...` | Move to `~/.config/xkb/symbols/` |
| `keyd` config ignored / `monitor` shows no swap | Unparseable config, or another `.conf` in `/etc/keyd/` failing (every file there is parsed) | Check `journalctl -eu keyd`; replace with a minimal ASCII config; `ls -la /etc/keyd/` |
| Keyboard unresponsive after config | Bad `keyd` config | **Backspace + Escape + Enter** to kill `keyd`; fix; reload |
| UTM/VM behaves differently from bare metal | Hypervisor evdev passthrough | Run `evtest` *inside* the VM |
| Works in apps, not in TTY | You edited XKB, not `keyd` | Install and configure `keyd` |
| `journalctl -eu keyd`: `failed to parse /etc/keyd/default.conf` | Config invalid, or another `.conf` in `/etc/keyd/` also failing | Write a minimal ASCII config; quarantine other `.conf` files; `keyd.rvaiya reload`; re-read the journal with `--since '1 minute ago'` (stale entries look like fresh failures) |
| Service active but `monitor` shows **no** swap | Config never loaded, or the unit runs a different `keyd` binary | `systemctl cat keyd` — the Exec line must point at the real binary |

## Bug-report info

```bash
./scripts/diagnose.sh
```

Paste the output (redact anything sensitive).
