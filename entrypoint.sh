#!/bin/bash
set -e

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <input_iso> <profile_name>"
  echo "Example: $0 /iso/proxmox-ve_8.4-1.iso pve-1"
  exit 1
fi

INPUT_ISO="$1"
PROFILE_NAME="$2"
ANSWER_FILE="/answers/${PROFILE_NAME}/answer.toml"

# Extract base name from input ISO and generate output name dynamically
ISO_BASENAME=$(basename "$INPUT_ISO" .iso)
OUTPUT_ISO="/out/${ISO_BASENAME}-auto-${PROFILE_NAME}.iso"

if [ ! -f "$ANSWER_FILE" ]; then
  echo "ERROR: Answer file not found at $ANSWER_FILE"
  exit 2
fi

echo "Preparing ISO for profile '$PROFILE_NAME'…"
echo "  ISO:    $INPUT_ISO"
echo "  Answer: $ANSWER_FILE"
echo "  Output: $OUTPUT_ISO"

# ==== key change: use `prepare-iso` ====
proxmox-auto-install-assistant prepare-iso \
  --fetch-from iso \
  --answer-file "$ANSWER_FILE" \
  --output "$OUTPUT_ISO" \
  "$INPUT_ISO"
