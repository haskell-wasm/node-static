#!/bin/sh

set -eu

node_ver=v25.2.0

apk add \
  clang \
  linux-headers \
  llvm \
  python3 \
  xz

cd "$(mktemp -d)"

curl -f -L --retry 5 https://nodejs.org/dist/$node_ver/node-$node_ver.tar.xz | tar xJ --strip-components=1
patch -p1 -i /workspace/lto.diff

make -j"$(nproc)" binary \
  AR=llvm-ar \
  CC=clang \
  CXX=clang++ \
  CONFIG_FLAGS="--enable-lto --fully-static" \
  LDFLAGS=-Wl,-z,stack-size=8388608 \
  VARIATION="static"

mkdir /workspace/dist
mv node-v*.tar.xz /workspace/dist
