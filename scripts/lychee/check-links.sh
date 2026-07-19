#!/usr/bin/env bash
set -Eeuo pipefail

if ! command -v lychee >&/dev/null; then
  echo "[ERROR] Lychee is not installed." >&2
  exit 1
fi

## Paths
THIS_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT=$(realpath -m "${THIS_DIR}/../..")
CWD="$(pwd)"
trap 'cd "${CWD}"' EXIT

## Variable defaults
BASE_URL=${LYCHEE_BASE_URL:-}
DEFAULT_CONFIG="${REPO_ROOT}/.lychee.toml"
LYCHEE_CONFIG_FILE="${LYCHEE_CONFIG:-}"
LYCHEE_ROOT_DIR="${HUGO_STATIC_FILES_DIR:-public}"
OFFLINE="${LYCHEE_OFFLINE:-false}"

## Help menu
function usage() {
  cat <<EOF
Usage: ${0} [OPTIONS]

Options:
  -h, --help          Print this help menu
  -u, -b, --base-url  Base URL for Lychee to check
  -c, --config-file   Path to a .lychee.toml
  -p, --root-dir      Path where Lychee should start scanning in offline mode
  -o, --offline       Run scan against locally rendered Hugo files
EOF
}

## Parse CLI options
function parse_args() {
  while [[ $# -gt 0 ]]; do
    case $1 in
    -h | --help)
      usage
      exit 0
      ;;
    -u | -b | --base-url)
      BASE_URL="${2}"
      shift 2
      ;;
    -c | --config-file)
      LYCHEE_CONFIG_FILE="${2}"
      shift 2
      ;;
    -p | --root-dir)
      LYCHEE_ROOT_DIR="${2}"
      shift 2
      ;;
    -o | --offline)
      OFFLINE="true"
      shift
      ;;
    *)
      echo "[ERROR] Invalid arg: ${1}" >&2
      usage
      exit 1
      ;;
    esac
  done
}

## Build Hugo site
function build_site() {
  if ! command -v hugo >&/dev/null; then
    echo "[ERROR] Hugo is not installed, cannot build site" >&2
    exit 1
  else
    echo "Building Hugo site"
    hugo
  fi
}

## Run lychee against local generated static files
function lychee_check_offline() {
  local rootDir
  rootDir="${1}"

  echo
  echo "Running offline Lychee check against public directory"
  lychee --offline --root-dir "${rootDir}" "${rootDir}"/**/*.html
}

## Run lychee against a live site
function lychee_check_online() {
  local baseUrl
  local lycheeConfig

  baseUrl="$1"
  lycheeConfig="$2"

  ## Build the command as an array
  local cmd=(
    lychee
    --base-url "${baseUrl}"
  )

  ## Add config file if provided
  if [[ -n "${lycheeConfig}" ]]; then
    if [[ ! -f "${lycheeConfig}" ]]; then
      echo "[ERROR] Could not find Lychee config at path: ${lycheeConfig}" >&2
      exit 1
    fi
    cmd+=(--config "${lycheeConfig}")
  fi

  ## Add the base URL as the input to check
  cmd+=("${baseUrl}")

  echo "Running Lychee command: ${cmd[*]}"
  "${cmd[@]}"
}

function main() {
  parse_args "${@}"

  ## Ensure base URL was given if running online mode
  if [[ -z "${BASE_URL}" ]]; then
    if [[ "${OFFLINE}" == "false" ]]; then
      echo "[ERROR] --base-url is missing." >&2
      exit 1
    fi
  fi

  ## Set default config file if none given
  if [[ -z "${LYCHEE_CONFIG_FILE}" ]]; then
    LYCHEE_CONFIG_FILE="${DEFAULT_CONFIG}"
  fi

  ## Local scan path
  if [[ -z "${LYCHEE_ROOT_DIR}" ]]; then
    LYCHEE_ROOT_DIR="public"
  fi

  echo "[DEBUG] Base URL: ${BASE_URL}"
  echo "[DEBUG] Lychee config: ${LYCHEE_CONFIG_FILE}"

  cd "${REPO_ROOT}"

  ## Run offline check
  if [[ "${OFFLINE}" == "true" ]]; then
    ## Build Hugo site
    build_site

    lychee_check_offline "${LYCHEE_ROOT_DIR}"

  ## Run online check
  else
    lychee_check_online "${BASE_URL}" "${LYCHEE_CONFIG_FILE}"
  fi
}

main "${@}"
