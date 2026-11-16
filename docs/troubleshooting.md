# Troubleshooting

| Symptom | Cause | Fix |
| --- | --- | --- |
| `sudo keyd monitor` →  command not found (Debian) | Binary renamed | Use `sudo keyd.rvaiya monitor` |
| `xmodmap` runs, keys unchanged in apps | You are on Wayland | Use `keyd` — see [wayland-vs-x11](wayland-vs-x11.md) |
| XKB edit reverted after update | `xkb-data` overwrote `/usr/share/...` | Move to `~/.config/xkb/symbols/` |
| `keyd` config ignored | Wrong key names | Re-identify with `evtest` + `keyd.rvaiya list-keys` |
| Keyboard unresponsive after config | Bad `keyd` config | **Backspace + Escape + Enter** to kill `keyd`; fix; reload |
| UTM/VM behaves differently from bare metal | Hypervisor evdev passthrough | Run `evtest` *inside* the VM |
| Works in apps, not in TTY | You edited XKB, not `keyd` | Install and configure `keyd` |

## Bug-report info

```bash
./scripts/diagnose.sh
```

Paste the output (redact anything sensitive).
