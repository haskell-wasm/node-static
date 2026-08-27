#!/usr/bin/env bash

set -euo pipefail

workdir=$(mktemp -d)
trap 'rm -rf "$workdir"' EXIT

cd "$workdir"

git clone --depth=1 --branch=v26.8.1 https://github.com/nodejs/node.git .

git apply "$OLDPWD/wasm-gdb-remote.diff"

git diff --minimal > "$OLDPWD/wasm-gdb-remote.diff"
