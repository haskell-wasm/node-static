#!/usr/bin/env bash

set -euo pipefail

node_ver=v26.9.0

cd "$(mktemp -d)"

curl -f -L https://nodejs.org/dist/$node_ver/node-$node_ver.tar.xz | tar xJ --strip-components=1
curl -f -L https://raw.githubusercontent.com/nodejs/node/$node_ver/tools/osx-codesign.sh -o tools/osx-codesign.sh
patch -p1 -i "$GITHUB_WORKSPACE/wasm-gdb-remote.diff"

make -j"$(sysctl -n hw.physicalcpu)" binary

mkdir "$GITHUB_WORKSPACE/dist"
mv node-v*.tar.xz "$GITHUB_WORKSPACE/dist"
