#!/usr/bin/env bash
set -euo pipefail

if ! command -v hugo &>/dev/null; then
  echo "[ERROR] hugo is not installed." >&2
  exit 1
fi

HUGO_HOST="${HUGO_HOST:-0.0.0.0}"
HUGO_PORT="${HUGO_PORT:-1313}"
DEV=false
HAS_USER_BASEURL=false
EXTRA_ARGS=()

function usage() {
  cat <<EOF
Usage:
  $(basename "${0}") [OPTIONS]

Options:
  -h, --help                          Print this help menu
  -b, --bind                <string>  IP address bind, i.e. 0.0.0.0, localhost, or 192.168.1.xxx (default: 0.0.0.0)
  -p, --port                <int>     Port to serve Hugo on (default: 1313)
  -u, --baseURL, --base-url <string>  Override the base URL. By default, it will be http://\$HUGO_HOST:\$HUGO_PORT.
  -d, -D, --dev                       Include draft content

Any additional --options are passed directly to the 'hugo server' command.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
  -h | --help)
    usage
    exit 0
    ;;
  -b | --bind)
    [[ $# -ge 2 ]] || {
      echo "[ERROR] Missing value for $1" >&2
      echo

      usage
      exit 1
    }

    HUGO_HOST="$2"
    shift 2
    ;;
  -p | --port)
    [[ $# -ge 2 ]] || {
      echo "[ERROR] Missing value for $1" >&2
      echo

      usage
      exit 1
    }

    [[ "$2" =~ ^[0-9]+$ ]] && [[ "$2" -ge 1 && "$2" -le 65535 ]] || {
      echo "[ERROR] Invalid port: $2" >&2
      echo

      usage
      exit 1
    }

    HUGO_PORT="$2"
    shift 2
    ;;
  -u | --baseURL | --base-url)
    [[ $# -ge 2 ]] || {
      echo "[ERROR] Missing value for $1" >&2
      echo
      usage
      exit 1
    }

    HAS_USER_BASEURL=true
    EXTRA_ARGS+=(--baseURL "$2")
    shift 2
    ;;
  --baseURL=* | --baseurl=* | --base-url=*)
    HAS_USER_BASEURL=true
    EXTRA_ARGS+=(--baseURL="${1#*=}")
    shift
    ;;
  -d | -D | --dev)
    DEV=true
    shift
    ;;
  --)
    shift
    EXTRA_ARGS+=("$@")
    break
    ;;
  *)
    EXTRA_ARGS+=("$1")
    shift
    ;;
  esac
done

## Build command as array
cmd=(
  hugo server
  --bind "${HUGO_HOST}"
  --port "${HUGO_PORT}"
  --appendPort=true
)

## Build base URL from host+port
HUGO_BASEURL="http://${HUGO_HOST}:${HUGO_PORT}"

## Add a default baseURL unless the user supplied one.
if [[ "${HAS_USER_BASEURL}" == "false" ]]; then
  cmd+=(--baseURL "$HUGO_BASEURL")
fi

## Enable drafts in dev mode
if [[ "${DEV}" == "true" ]]; then
  cmd+=(-D)
fi

cmd+=("${EXTRA_ARGS[@]}")

printf "Starting Hugo server: "
printf '%q ' "${cmd[@]}"
echo

exec "${cmd[@]}"
