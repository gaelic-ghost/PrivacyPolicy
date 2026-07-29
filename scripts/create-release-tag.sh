#!/bin/sh
set -eu

usage() {
  printf '%s\n' "Usage: scripts/create-release-tag.sh vMAJOR.MINOR.PATCH"
}

if [ "$#" -ne 1 ]; then
  usage >&2
  exit 64
fi

tag_name=$1
case "$tag_name" in
  v[0-9]*.[0-9]*.[0-9]*) ;;
  *)
    usage >&2
    printf '%s\n' "Release tag must use vMAJOR.MINOR.PATCH, for example v1.2.3." >&2
    exit 64
    ;;
esac

if [ ! -d .git ]; then
  printf '%s\n' "Release tags must be created from the primary PrivacyPolicy checkout on main, not from a linked worktree." >&2
  exit 2
fi

if ! git diff --quiet || ! git diff --cached --quiet; then
  printf '%s\n' "Release tag creation needs a clean primary checkout. Commit, stash, or discard local changes before tagging." >&2
  exit 1
fi

git fetch origin main --tags

local_head=$(git rev-parse HEAD)
remote_main=$(git rev-parse origin/main)
if [ "$local_head" != "$remote_main" ]; then
  printf '%s\n' "Release tag creation needs HEAD to equal origin/main. Fast-forward the primary checkout before tagging." >&2
  exit 1
fi

if git rev-parse -q --verify "refs/tags/$tag_name" >/dev/null; then
  printf '%s\n' "Release tag $tag_name already exists. Choose a new version or inspect the existing release instead of retagging." >&2
  exit 1
fi

git tag -a "$tag_name" -m "Release $tag_name"
git push origin "$tag_name"
printf '%s\n' "Created and pushed $tag_name from origin/main. GitHub Actions will build the release artifact and create a draft release."
