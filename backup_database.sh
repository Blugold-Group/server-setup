#!/bin/bash

# Configuration
DB_FILE="/home/pi/CTF_Scoreboard/database.db"   # Path to the original database file
BACKUP_DIR="/backups"                 # Path to the backup directory

# Generate a timestamped filename for the backup
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="${BACKUP_DIR}/database_backup_${TIMESTAMP}.db"

# Check if the backup directory exists
if [ ! -d "$BACKUP_DIR" ]; then
  echo "Backup directory does not exist: $BACKUP_DIR"
  exit 1
fi

# Calculate the hash of the current database file (SHA256 hash)
DB_HASH=$(sha256sum "$DB_FILE" | awk '{ print $1 }')

# Check if any existing backup in the backup directory has the same hash
MATCH_FOUND=0
for existing_backup in "$BACKUP_DIR"/*.db; do
  # Get the hash of the existing backup file
  if [ -f "$existing_backup" ]; then
    BACKUP_HASH=$(sha256sum "$existing_backup" | awk '{ print $1 }')

    # Compare the hashes
    if [ "$DB_HASH" == "$BACKUP_HASH" ]; then
      MATCH_FOUND=1
      break
    fi
  fi
done

# If no matching hash is found, perform the backup
if [ "$MATCH_FOUND" -eq 0 ]; then
  cp "$DB_FILE" "$BACKUP_FILE"
  echo "Backup created: $BACKUP_FILE"
else
  echo "No backup created: Hash matches an existing backup."
fi
