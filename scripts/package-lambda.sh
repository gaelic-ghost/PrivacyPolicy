#!/bin/sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
project_dir=$(CDPATH= cd -- "$script_dir/.." && pwd)

cd "$project_dir"
swift package --allow-network-connections docker archive --products App --base-docker-image swift:6.2.4-amazonlinux2

archive_path=.build/plugins/AWSLambdaPackager/outputs/AWSLambdaPackager/App/App.zip
binary_description=$(unzip -p "$archive_path" bootstrap | file -)
case "$binary_description" in
  *x86-64*) ;;
  *)
    printf '%s\n' "PrivacyPolicy Lambda archive contains an unsupported bootstrap binary: $binary_description. The deployed function requires an x86-64 Linux bootstrap." >&2
    exit 1
    ;;
esac
