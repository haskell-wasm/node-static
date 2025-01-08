#!/bin/sh

set -eu

node_ver=v23.6.0

apk add \
  clang \
  linux-headers \
  llvm \
  python3 \
  xz

cd "$(mktemp -d)"

curl -f -L --retry 5 https://nodejs.org/dist/$node_ver/node-$node_ver.tar.xz | tar xJ --strip-components=1
patch -p1 -i /workspace/bump-v8-wasm-limits.diff
patch -p1 -i /workspace/lto.diff
patch -p1 -i /workspace/use-etc-ssl-certs.diff

make -j"$(nproc)" binary \
  AR=llvm-ar \
  CC=clang \
  CXX=clang++ \
  CONFIG_FLAGS="--enable-lto --fully-static --openssl-use-def-ca-store --v8-disable-maglev" \
  VARIATION="static"

mkdir /workspace/dist
mv node-v*.tar.xz /workspace/dist
