#!/usr/bin/env bash
set -euo pipefail

TOOL=proxmox-auto-install-assistant

usage() {
  cat <<'EOF'
Usage:
  docker run -it --rm \
      -v "$PWD/iso:/iso" -v "$PWD/out:/out" my-image:latest \
      prepare-iso --fetch-from http \
        --url https://<pdm-ip>}:8443/api2/json/auto-install/answer \
        --answer-auth-token <token> \
        --cert-fingerprint <fp> \
        --output /out/result.iso \
        /iso/INPUT.iso

  docker run -it --rm \
      -v "$PWD/iso:/iso" -v "$PWD/out:/out" -v "$PWD/answers:/answers" my-image:latest \
      profile /iso/proxmox-ve_8.4-1.iso pve-1
EOF
}

cmd="${1:-}"

case "$cmd" in
  ""|-h|--help|help)
    usage
    [ -z "$cmd" ] && exit 1 || exit 0
    ;;

  profile)
    # ---- convenience mode ----
    shift
    if [ "$#" -ne 2 ]; then
      echo "ERROR: profile mode expects: profile <input_iso> <profile_name>" >&2
      exit 1
    fi
    INPUT_ISO="$1"
    PROFILE_NAME="$2"
    ANSWER_FILE="/answers/${PROFILE_NAME}/answer.toml"
    ISO_BASENAME="$(basename "$INPUT_ISO" .iso)"
    OUTPUT_ISO="/out/${ISO_BASENAME}-auto-${PROFILE_NAME}.iso"

    [ -f "$INPUT_ISO" ]   || { echo "ERROR: input ISO not found: $INPUT_ISO" >&2; exit 2; }
    [ -f "$ANSWER_FILE" ] || { echo "ERROR: answer file not found: $ANSWER_FILE" >&2; exit 2; }

    echo "Preparing ISO for profile '$PROFILE_NAME'…"
    echo "  ISO:    $INPUT_ISO"
    echo "  Answer: $ANSWER_FILE"
    echo "  Output: $OUTPUT_ISO"

    exec "$TOOL" prepare-iso \
      --fetch-from iso \
      --answer-file "$ANSWER_FILE" \
      --output "$OUTPUT_ISO" \
      "$INPUT_ISO"
    ;;

  *)
    # ---- passthrough mode: prepare-iso / validate-answer / device-info / ... ----
    exec "$TOOL" "$@"
    ;;
esac