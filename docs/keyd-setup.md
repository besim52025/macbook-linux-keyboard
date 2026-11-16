# Setting up `keyd` (Wayland / X11 / TTY)

`keyd` remaps keys at the Linux input layer (`evdev` + `uinput`), so it works
identically under Wayland, X11, and the text console.

## 1. Install

```bash
sudo apt install keyd        # Debian / Ubuntu
sudo dnf install keyd        # Fedora
sudo pacman -S keyd          # Arch
```

## 2. Debian-only: use `keyd.rvaiya`

On Debian the real binary is renamed to **`keyd.rvaiya`**. The systemd service
is still `keyd`.

```bash
dpkg -S "$(command -v keyd.rvaiya)"
sudo systemctl enable --now keyd
systemctl status keyd
```

## 3. Identify your keys

### Option A: `keyd monitor`

```bash
sudo keyd.rvaiya monitor
# Press each key, note the key name. Ctrl+C to stop.
```

### Option B: `evtest` (always works)

```bash
sudo apt install evtest
sudo evtest
# Pick your keyboard, press each key, note the KEY_* name.
```

Cross-reference `KEY_*` →  `keyd` name:

```bash
keyd.rvaiya list-keys | less
```

| `evtest` | `keyd` |
| --- | --- |
| `KEY_GRAVE` | `grave` |
| `KEY_102ND` | `102nd` |
| `KEY_LEFTMETA` | `leftmeta` |
| `KEY_APOSTROPHE` | `apostrophe` |
| `KEY_BACKSLASH` | `backslash` |

## 4. Write the config

```bash
sudo nano /etc/keyd/default.conf
```

```ini
[ids]
*

[main]
grave = 102nd
102nd = grave
```

Multiple configs go in `/etc/keyd/*.conf`; use `[ids]` to scope each file.

## 5. Apply

```bash
sudo keyd.rvaiya reload
```

## 6. Test

Try a native Wayland app, an X11 app, and a TTY (`Ctrl+Alt+F3`). All three
should show the corrected keys.

## 7. Emergency exit

```
Backspace + Escape + Enter
```

Terminates `keyd`, restoring default mapping.

## 8. Logs

```bash
sudo journalctl -eu keyd
```
