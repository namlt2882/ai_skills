#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/pinchtab/pinchtab"
IMAGE_TAG="pinchtab-local:latest"

if ! command -v git >/dev/null 2>&1; then
  echo "Error: git is required but not found in PATH." >&2
  exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "Error: docker is required but not found in PATH." >&2
  exit 1
fi

if ! docker info >/dev/null 2>&1; then
  echo "Error: docker daemon does not appear to be running or is not accessible." >&2
  exit 1
fi

tmp_parent="${TMPDIR:-/tmp}"
tmp_dir="$(mktemp -d "${tmp_parent%/}/pinchtab-build-XXXXXX")"

cleanup() {
  if [[ -n "${tmp_dir:-}" && -d "${tmp_dir}" ]]; then
    rm -rf "${tmp_dir}"
  fi
}
trap cleanup EXIT

echo "Cloning ${REPO_URL} into ${tmp_dir}"
git clone --depth 1 "${REPO_URL}" "${tmp_dir}"

echo "Building Docker image ${IMAGE_TAG}"
docker build -t "${IMAGE_TAG}" "${tmp_dir}"

echo "Build complete: ${IMAGE_TAG}"
