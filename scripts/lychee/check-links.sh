#!/usr/bin/env bash
set -Eeuo pipefail

shopt -s globstar nullglob

THIS_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT="$(realpath -m "${THIS_DIR}/../..")"

PUBLIC_DIR="${REPO_ROOT}/public"
SITE_URL=""
CHECK_MODE="live"
LYCHEE_CONFIG_FILE=""

CWD="$(pwd)"
trap 'cd "${CWD}"' EXIT

usage() {
  cat <<EOF
Usage:
  ${0##*/} [OPTIONS]

Check a Hugo site's local build output or deployed live site.

Modes:
  --offline
      Build the Hugo site, then check generated local HTML files.
      This is the recommended pre-deployment check.

  --live
      Check the deployed site URL. Requires --site-url.

Options:
  -o, --offline                Build Hugo and check local generated files
  -l, --live                   Check the deployed site URL (default)
  -u, --site-url URL           Deployed site URL, including https://
  -p, --public-dir DIRECTORY   Hugo generated output directory
  -c, --config-file FILE       Optional Lychee TOML configuration file
  -h, --help                   Print this help menu

Environment:
  LYCHEE_SITE_URL              Default URL for --site-url
  LYCHEE_PUBLIC_DIR            Default generated output directory
  LYCHEE_CONFIG                Default Lychee TOML configuration file

Examples:
  ${0##*/} --offline
  ${0##*/} --offline --public-dir ./public
  ${0##*/} --live --site-url https://techobyte.cc
  LYCHEE_SITE_URL=https://techobyte.cc ${0##*/}
EOF
}

error() {
  echo "[ERROR] $*" >&2
  exit 1
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

build_site() {
  command_exists hugo || error "Hugo is required for offline mode but was not found in PATH"

  echo "Building Hugo site"

  if ! hugo --cleanDestinationDir; then
    error "Hugo build failed"
  fi
}

validate_site_url() {
  local site_url="$1"

  if [[ ! "${site_url}" =~ ^https?:// ]]; then
    error "--site-url must include http:// or https://; received: ${site_url}"
  fi
}

while [[ $# -gt 0 ]]; do
  case "$1" in
  -o | --offline)
    CHECK_MODE="offline"
    shift
    ;;
  -l | --live)
    CHECK_MODE="live"
    shift
    ;;
  -u | --site-url | --base-url)
    [[ $# -ge 2 ]] || error "$1 requires a URL argument"
    [[ -n "$2" ]] || error "$1 requires a non-empty URL argument"

    SITE_URL="$2"
    shift 2
    ;;
  -p | --public-dir | --root-dir)
    [[ $# -ge 2 ]] || error "$1 requires a directory argument"
    [[ -n "$2" ]] || error "$1 requires a non-empty directory argument"

    PUBLIC_DIR="$(realpath -m "$2")"
    shift 2
    ;;
  -c | --config-file)
    [[ $# -ge 2 ]] || error "$1 requires a file argument"
    [[ -n "$2" ]] || error "$1 requires a non-empty file argument"

    LYCHEE_CONFIG_FILE="$(realpath -m "$2")"
    shift 2
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    error "Invalid option: $1"
    ;;
  esac
done

command_exists lychee || error "Lychee is required but was not found in PATH"

if [[ -z "${SITE_URL}" ]]; then
  SITE_URL="${LYCHEE_SITE_URL:-}"
fi

if [[ -z "${LYCHEE_CONFIG_FILE}" && -n "${LYCHEE_CONFIG:-}" ]]; then
  LYCHEE_CONFIG_FILE="$(realpath -m "${LYCHEE_CONFIG}")"
fi

if [[ -z "${LYCHEE_CONFIG_FILE}" && -f "${REPO_ROOT}/.lychee.toml" ]]; then
  LYCHEE_CONFIG_FILE="${REPO_ROOT}/.lychee.toml"
fi

if [[ -n "${LYCHEE_CONFIG_FILE}" && ! -f "${LYCHEE_CONFIG_FILE}" ]]; then
  error "Lychee configuration file does not exist: ${LYCHEE_CONFIG_FILE}"
fi

cd "${REPO_ROOT}"

LYCHEE_CONFIG_ARGS=()

if [[ -n "${LYCHEE_CONFIG_FILE}" ]]; then
  LYCHEE_CONFIG_ARGS=(
    --config "${LYCHEE_CONFIG_FILE}"
  )
fi

case "${CHECK_MODE}" in
offline)
  build_site

  if [[ ! -d "${PUBLIC_DIR}" ]]; then
    error "Hugo output directory does not exist after build: ${PUBLIC_DIR}"
  fi

  HTML_FILES=("${PUBLIC_DIR}"/**/*.html)

  if [[ "${#HTML_FILES[@]}" -eq 0 ]]; then
    error "No HTML files found under Hugo output directory: ${PUBLIC_DIR}"
  fi

  echo
  echo "[ Running Lychee in offline mode against Hugo static files ]"
  echo "Public directory: ${PUBLIC_DIR}"

  lychee \
    "${LYCHEE_CONFIG_ARGS[@]}" \
    --offline \
    --root-dir "${PUBLIC_DIR}" \
    --index-files index.html \
    --fallback-extensions html \
    "${HTML_FILES[@]}"
  ;;

live)
  [[ -n "${SITE_URL}" ]] || error "Live mode requires --site-url URL or LYCHEE_SITE_URL"
  validate_site_url "${SITE_URL}"

  echo
  echo "[ Running Lychee against live site ]"
  echo "Site URL: ${SITE_URL}"

  lychee \
    "${LYCHEE_CONFIG_ARGS[@]}" \
    "${SITE_URL}"
  ;;

*)
  error "Unsupported check mode: ${CHECK_MODE}"
  ;;
esac
