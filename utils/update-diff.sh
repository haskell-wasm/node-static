#!/usr/bin/env bash

set -euo pipefail

workdir=$(mktemp -d)
trap 'rm -rf "$workdir"' EXIT

cd "$workdir"

git clone --depth=1 --branch=v26.1.0 https://github.com/nodejs/node.git .

git apply "$OLDPWD/lto.diff"

git diff --minimal > "$OLDPWD/lto.diff"
