#!/usr/bin/env bash
set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"${CODEXBAR_BIN:-${HOME}/.local/bin/codexbar}" usage --provider codex --source oauth --format json --no-color 2>/dev/null |
    jq -ce -f "$SCRIPT_DIR/codexbar.jq" ||
    printf '{"text":"  —","tooltip":"Codex usage unavailable","class":"stale","percentage":0}\n'
