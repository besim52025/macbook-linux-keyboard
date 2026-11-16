#!/usr/bin/env bash
# Collect keyboard-related system info for bug reports.
# Redact anything sensitive before posting.
set -u

echo "=== Date ==="; date

echo; echo "=== Distro ==="
[ -r /etc/os-release ] && { . /etc/os-release; echo "${PRETTY_NAME:-unknown}"; }
uname -a

echo; echo "=== Display server ==="
echo "XDG_SESSION_TYPE=${XDG_SESSION_TYPE:-unknown}"
echo "XDG_CURRENT_DESKTOP=${XDG_CURRENT_DESKTOP:-unknown}"
[ -n "${WAYLAND_DISPLAY:-}" ] && echo "WAYLAND_DISPLAY=$WAYLAND_DISPLAY"

echo; echo "=== keyd binaries ==="
for b in keyd keyd.rvaiya; do
  if command -v "$b" >/dev/null 2>&1; then
    printf '%-14s %s\n' "$b" "$(command -v "$b")"
    dpkg -S "$(command -v "$b")" 2>/dev/null || true
  fi
done

echo; echo "=== keyd service ==="
systemctl status keyd --no-pager 2>&1 | sed -n '1,15p'

echo; echo "=== /etc/keyd configs ==="
if [ -d /etc/keyd ]; then
  ls -la /etc/keyd
  for f in /etc/keyd/*.conf; do
    [ -f "$f" ] || continue
    echo "--- $f ---"; sed 's/^/  /' "$f"
  done
else
  echo "(no /etc/keyd directory)"
fi

echo; echo "=== /etc/default/keyboard ==="
[ -r /etc/default/keyboard ] && sed 's/^/  /' /etc/default/keyboard || echo "(not readable)"

echo; echo "=== evtest devices (no grab) ==="
if command -v evtest >/dev/null 2>&1; then
  (echo "" | evtest 2>/dev/null | sed -n '1,60p') || true
else
  echo "evtest not installed (sudo apt install evtest)"
fi

echo; echo "Done. Redact anything sensitive before posting."
