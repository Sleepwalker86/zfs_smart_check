#!/bin/bash

# Konfiguration
EMAIL="your_email@email.de"
LOG_FILE="/root/zfs_smart_check.log"
POOL_ERROR=0
SMART_ERROR=0

# Alle Ausgaben in Log-Datei schreiben
exec > $LOG_FILE 2>&1

# Aktuelles Datum
echo "Prüfung gestartet am: $(date)"
echo "-------------------------------"

# ZFS-Pools prüfen
echo "ZFS-Pool-Status:"
zpool status -x
if [[ $? -ne 0 ]]; then
  echo "Fehler bei der ZFS-Prüfung!"
  POOL_ERROR=1
fi

# Pools auf Fehler prüfen
POOLS=$(zpool list -H -o name)
for POOL in $POOLS; do
  STATUS=$(zpool status $POOL | grep -E "state: ONLINE")
  if [[ -z "$STATUS" ]]; then
    echo "WARNUNG: Pool $POOL ist nicht ONLINE!"
    POOL_ERROR=1
  else
    echo "Pool $POOL ist ONLINE und in Ordnung."
  fi
done

# SMART-Überprüfung
echo "SMART-Status der Festplatten:"
DISKS=$(lsblk -dn -o NAME | grep -E '^sd|nvme')
for DISK in $DISKS; do
  echo "Prüfe /dev/$DISK..."
  if smartctl -H /dev/$DISK | grep -q "FAILED"; then
    echo "WARNUNG: /dev/$DISK meldet einen Fehler im SMART-Test!"
    SMART_ERROR=1
  else
    echo "/dev/$DISK: SMART-Test bestanden."
  fi

  PROBLEMATIC_ATTRIBUTES=$(smartctl -A /dev/$DISK | awk '$1 == 5 || $1 == 197 || $1 == 198 { if ($10 > 0) print }')
  if [[ -n "$PROBLEMATIC_ATTRIBUTES" ]]; then
    echo "WARNUNG: /dev/$DISK zeigt problematische SMART-Werte!"
    echo "$PROBLEMATIC_ATTRIBUTES"
    SMART_ERROR=1
  else
    echo "/dev/$DISK: Keine problematischen SMART-Werte gefunden."
  fi
done

# Fehler melden
if [[ $POOL_ERROR -eq 1 || $SMART_ERROR -eq 1 ]]; then
  echo "Fehler erkannt, sende E-Mail..."
  cat "$LOG_FILE" | sendmail -v "$EMAIL"
else
  echo "Systemzustand in Ordnung. Keine E-Mail gesendet."
fi

echo "Prüfung abgeschlossen."
