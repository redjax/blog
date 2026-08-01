#!/usr/bin/env bash
set -euo pipefail

if ! command -v hugo &>/dev/null; then
  echo "[ERROR] hugo is not installed."
  exit 1
fi

function usage() {
  cat <<EOF

Usage:
  $(basename "$0") path/to/page-name.md

Examples:
  $(basename "$0") posts/example.md
  $(basename "$0") posts/2026/post-name/index.md
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
  -h | --help)
    usage
    exit 0
    ;;

  *)
    PAGE_PATH="$1"
    shift
    ;;
  esac
done

if [[ -z "${PAGE_PATH:-}" ]]; then
  usage
  exit 1
fi

if ! hugo new "$PAGE_PATH"; then
  echo "[ERROR] Failed creating page: $PAGE_PATH" >&2
  echo

  usage
  exit 1
fi

echo "Created new page: $PAGE_PATH"
