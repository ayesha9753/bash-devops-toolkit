#!/usr/bin/env bash
# backup.sh — timestamped tar.gz backup of a directory, with retention cleanup.
# Usage: ./backup.sh [source_dir] [backup_dir] [keep_days]
set -euo pipefail

SOURCE_DIR="${1:-/var/www}"
BACKUP_DIR="${2:-/var/backups}"
KEEP_DAYS="${3:-7}"
STAMP="$(date '+%Y%m%d-%H%M%S')"
ARCHIVE="${BACKUP_DIR}/backup-${STAMP}.tar.gz"

mkdir -p "$BACKUP_DIR"
echo "Backing up ${SOURCE_DIR} -> ${ARCHIVE}"
tar -czf "$ARCHIVE" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"
echo "Created: $(du -h "$ARCHIVE" | cut -f1)"

echo "Removing backups older than ${KEEP_DAYS} days..."
find "$BACKUP_DIR" -name 'backup-*.tar.gz' -mtime +"$KEEP_DAYS" -print -delete
echo "Done."
