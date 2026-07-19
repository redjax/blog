#!/usr/bin/env bash
set -Eeuo pipefail

INSTALL_DIR="${LYCHEE_INSTALL_DIR:-"${HOME}/.local/bin"}"
LYCHEE_REPO="lycheeverse/lychee"

function usage() {
  cat <<EOF
Usage: ${0} [OPTIONS] [VERSION]

Installs lychee from GitHub releases.

Options:
  -h, --help          Print this help message
  -f, --force         Force reinstall
  -d, --install-dir   Installation directory (default: ~/.local/bin)

Examples:
  ${0}                    # Install latest version
  ${0} 0.18.1             # Install specific version
  ${0} --force            # Reinstall
  ${0} -d /usr/local/bin  # Install to custom location
EOF
}

function detect_arch() {
  local arch
  arch="$(uname -m)"

  case "${arch}" in
  x86_64 | amd64) echo "x86_64" ;;
  aarch64 | arm64) echo "aarch64" ;;
  armv7l | armhf) echo "armv7" ;;
  *)
    echo "[ERROR] Unsupported architecture: ${arch}" >&2
    exit 1
    ;;
  esac
}

function detect_os() {
  local os
  os="$(uname -s | tr '[:upper:]' '[:lower:]')"

  case "${os}" in
  linux) echo "unknown-linux-gnu" ;;
  darwin) echo "apple-darwin" ;;
  *)
    echo "[ERROR] Unsupported OS: ${os}" >&2
    exit 1
    ;;
  esac
}

function get_latest_version() {
  local version
  version="$(curl -sL "https://api.github.com/repos/${LYCHEE_REPO}/releases/latest" |
    grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')"

  if [[ -z "${version}" ]]; then
    echo "[ERROR] Failed to fetch latest version from GitHub" >&2
    exit 1
  fi

  echo "${version}"
}

function download_lychee() {
  local version="${1}"
  local arch os filename url

  arch="$(detect_arch)"
  os="$(detect_os)"
  filename="lychee-${version}-${arch}-${os}.tar.gz"
  url="https://github.com/${LYCHEE_REPO}/releases/download/${version}/${filename}"

  echo "[INFO] Downloading lychee ${version}"

  if command -v curl &>/dev/null; then
    curl -sLO "${url}"
  elif command -v wget &>/dev/null; then
    wget -q "${url}"
  else
    echo "[ERROR] Neither curl nor wget found" >&2
    exit 1
  fi

  if [[ ! -f "${filename}" ]]; then
    echo "[ERROR] Download failed" >&2
    exit 1
  fi
}

function install_lychee() {
  local filename="${1}"
  local force="${2:-false}"

  if [[ -f "${INSTALL_DIR}/lychee" ]] && [[ "${force}" != "true" ]]; then
    echo "[WARNING] Lychee already installed at ${INSTALL_DIR}/lychee"
    echo "[WARNING] Use --force to reinstall"

    return 0
  fi

  mkdir -p "${INSTALL_DIR}"
  tar -xzf "${filename}"
  rm -f "${filename}"

  if [[ -f "./lychee" ]]; then
    mv -f "./lychee" "${INSTALL_DIR}/lychee"
    chmod +x "${INSTALL_DIR}/lychee"
  else
    local binary
    binary="$(find . -name "lychee" -type f | head -n1)"

    if [[ -n "${binary}" ]]; then
      mv -f "${binary}" "${INSTALL_DIR}/lychee"
      chmod +x "${INSTALL_DIR}/lychee"
    else
      echo "[ERROR] Could not find lychee binary" >&2
      exit 1
    fi
  fi

  rm -rf lychee* 2>/dev/null || true
  echo "[INFO] Installed to ${INSTALL_DIR}/lychee"
}

## Parse arguments
FORCE="false"
VERSION=""

while [[ $# -gt 0 ]]; do
  case "${1}" in
  -h | --help)
    usage
    exit 0
    ;;
  -f | --force)
    FORCE="true"
    shift
    ;;
  -d | --install-dir)
    INSTALL_DIR="${2}"
    shift 2
    ;;
  -*)
    echo "[ERROR] Unknown option: ${1}" >&2
    usage
    exit 1
    ;;
  *)
    VERSION="${1}"
    shift
    ;;
  esac
done

VERSION="${VERSION:-$(get_latest_version)}"

download_lychee "${VERSION}"
install_lychee "lychee-${VERSION}-$(detect_arch)-$(detect_os).tar.gz" "${FORCE}"

if [[ ":${PATH}:" != *":${INSTALL_DIR}:"* ]]; then
  echo "[WARNING] ${INSTALL_DIR} is not in PATH"
  echo "[INFO] Add to PATH: export PATH=\"${INSTALL_DIR}:\$PATH\""
fi

echo "[INFO] Finished installing Lychee"
