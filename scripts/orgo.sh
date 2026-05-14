#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${ORGO_BASE_URL:-https://www.orgo.ai/api}"
COMPUTER_ID="${ORGO_COMPUTER_ID:-da19c9f7-ff59-452e-b66b-9f5abb73b9a0}"
ARTIFACT_DIR="${ORGO_ARTIFACT_DIR:-artifacts}"

usage() {
  cat <<'USAGE'
Usage:
  bash scripts/orgo.sh status
  bash scripts/orgo.sh screenshot [output.png]
  bash scripts/orgo.sh bash "command"
  bash scripts/orgo.sh click X Y
  bash scripts/orgo.sh type "text"
  bash scripts/orgo.sh key "Enter|Tab|ctrl+l|ctrl+r|alt+Tab|..."

Required environment:
  ORGO_API_KEY      Orgo API key stored as a Codex Cloud secret.

Optional environment:
  ORGO_COMPUTER_ID  Defaults to Orgo Computer 2.
  ORGO_BASE_URL     Defaults to https://www.orgo.ai/api.
USAGE
}

need_key() {
  if [[ -z "${ORGO_API_KEY:-}" ]]; then
    echo "Blocker: ORGO_API_KEY is not set in this Codex Cloud environment." >&2
    echo "Add the Orgo API key as a Codex Cloud secret named ORGO_API_KEY, then rerun." >&2
    exit 2
  fi
}

api_get() {
  need_key
  curl -fsS -H "Authorization: Bearer ${ORGO_API_KEY}" "$BASE_URL$1"
}

api_post() {
  need_key
  local path="$1"
  local body="${2:-{}}"
  curl -fsS -X POST "$BASE_URL$path" \
    -H "Authorization: Bearer ${ORGO_API_KEY}" \
    -H 'Content-Type: application/json' \
    --data "$body"
}

pretty_json() {
  python3 -m json.tool
}

json_escape() {
  python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))'
}

case "${1:-}" in
  status)
    response=$(api_get "/computers/${COMPUTER_ID}")
    printf '%s\n' "$response" | pretty_json
    ;;
  screenshot)
    mkdir -p "$ARTIFACT_DIR"
    out="${2:-$ARTIFACT_DIR/orgo-computer2-$(date +%Y%m%d-%H%M%S).png}"
    response=$(api_get "/computers/${COMPUTER_ID}/screenshot")
    image=$(printf '%s\n' "$response" | python3 -c 'import json,sys; print(json.load(sys.stdin)["image"])')
    if [[ "$image" == data:image/* ]]; then
      printf '%s' "$image" | sed 's/^data:image\/[^;]*;base64,//' | base64 --decode > "$out"
    elif [[ "$image" == http://* || "$image" == https://* ]]; then
      curl -fsSL "$image" -o "$out"
    else
      echo "Unsupported screenshot payload from Orgo" >&2
      exit 1
    fi
    echo "$out"
    ;;
  bash)
    shift
    [[ $# -gt 0 ]] || { usage; exit 1; }
    command_text="$*"
    body=$(printf '%s' "$command_text" | json_escape | python3 -c 'import json,sys; print(json.dumps({"command": json.load(sys.stdin)}))')
    response=$(api_post "/computers/${COMPUTER_ID}/bash" "$body")
    printf '%s\n' "$response" | pretty_json
    ;;
  click)
    [[ $# -eq 3 ]] || { usage; exit 1; }
    response=$(api_post "/computers/${COMPUTER_ID}/click" "{\"x\":$2,\"y\":$3}")
    printf '%s\n' "$response" | pretty_json
    ;;
  type)
    shift
    [[ $# -gt 0 ]] || { usage; exit 1; }
    text="$*"
    body=$(printf '%s' "$text" | json_escape | python3 -c 'import json,sys; print(json.dumps({"text": json.load(sys.stdin)}))')
    response=$(api_post "/computers/${COMPUTER_ID}/type" "$body")
    printf '%s\n' "$response" | pretty_json
    ;;
  key)
    shift
    [[ $# -gt 0 ]] || { usage; exit 1; }
    key="$*"
    body=$(printf '%s' "$key" | json_escape | python3 -c 'import json,sys; print(json.dumps({"key": json.load(sys.stdin)}))')
    response=$(api_post "/computers/${COMPUTER_ID}/key" "$body")
    printf '%s\n' "$response" | pretty_json
    ;;
  -h|--help|help|"")
    usage
    ;;
  *)
    usage
    exit 1
    ;;
esac
