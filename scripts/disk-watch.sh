#!/usr/bin/env bash
# disk-watch.sh — warn when any mounted filesystem crosses a usage threshold.
# Usage: ./disk-watch.sh [threshold_percent]   (default 85) — cron-friendly, exit 1 on breach.
set -euo pipefail

THRESHOLD="${1:-85}"
BREACH=0

while read -r filesystem size used avail pct mountpoint; do
  usage="${pct%\%}"
  if [ "$usage" -ge "$THRESHOLD" ]; then
    echo "WARNING: ${mountpoint} (${filesystem}) at ${usage}% — ${avail} free"
    BREACH=1
  fi
done < <(df -P --output=source,size,used,avail,pcent,target | tail -n +2)

[ "$BREACH" -eq 0 ] && echo "OK: all filesystems below ${THRESHOLD}%"
exit "$BREACH"
