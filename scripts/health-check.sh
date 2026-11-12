#!/usr/bin/env bash
# health-check.sh — quick server health report: CPU, memory, disk, failed services.
set -euo pipefail

echo "=== $(hostname) — $(date '+%Y-%m-%d %H:%M:%S') ==="
echo
echo "-- Uptime & load --"
uptime
echo
echo "-- Memory --"
free -h
echo
echo "-- Disk (filesystems over 1G) --"
df -h --output=source,size,used,avail,pcent,target | awk 'NR==1 || $6=="/" || $6 ~ /^\/(home|var|data)/'
echo
echo "-- Top 5 processes by memory --"
ps aux --sort=-%mem | head -6
echo
if command -v systemctl >/dev/null 2>&1; then
  echo "-- Failed systemd services --"
  systemctl --failed --no-legend || true
fi
echo
echo "Health check complete."
