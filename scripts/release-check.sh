#!/bin/sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
project_dir=$(CDPATH= cd -- "$script_dir/.." && pwd)

usage() {
  printf '%s\n' "Usage: scripts/release-check.sh [--scan-only]"
}

scan_only=false
case "${1:-}" in
  "") ;;
  --scan-only) scan_only=true ;;
  -h|--help) usage; exit 0 ;;
  *) usage >&2; exit 64 ;;
esac

if ! command -v docker >/dev/null 2>&1; then
  printf '%s\n' "Release scan cannot run because Docker is unavailable. Start Colima or Docker Desktop, then retry." >&2
  exit 1
fi

cd "$project_dir"

printf '%s\n' "Scanning Git history for secrets with Gitleaks…"
docker run --rm \
  --volume "$project_dir:/repo:ro" \
  --workdir /repo \
  zricethezav/gitleaks:v8.27.2 \
  git --redact --log-opts="--all" /repo

printf '%s\n' "Scanning the release working tree for secrets with Gitleaks…"
docker run --rm \
  --volume "$project_dir:/repo:ro" \
  --workdir /repo \
  zricethezav/gitleaks:v8.27.2 \
  dir --redact /repo

printf '%s\n' "Scanning tracked source and Git history for high-confidence PII…"
python3 scripts/scan-public-data.py

if [ "$scan_only" = true ]; then
  printf '%s\n' "Release data scan passed."
  exit 0
fi

printf '%s\n' "Running Swift tests…"
swift test

printf '%s\n' "Installing pinned infrastructure dependencies…"
pnpm --dir infrastructure install --frozen-lockfile

printf '%s\n' "Running infrastructure validation…"
pnpm --dir infrastructure lint

printf '%s\n' "Release checks passed."
