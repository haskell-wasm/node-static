#!/bin/sh

set -eu

node_ver=v22.0.0

apk add \
  clang \
  linux-headers \
  lld \
  llvm \
  python3 \
  xz

cd "$(mktemp -d)"

curl -f -L --retry 5 https://nodejs.org/dist/$node_ver/node-$node_ver.tar.gz | tar xz --strip-components=1
patch -p1 -i /workspace/node-clang-lto.diff
patch -p1 -i /workspace/use-etc-ssl-certs.patch

make -j"$(nproc)" binary \
  AR="llvm-ar" \
  CC="clang" \
  CXX="clang++" \
  CONFIG_FLAGS="--enable-lto --experimental-enable-pointer-compression --fully-static --openssl-use-def-ca-store" \
  VARIATION="static"

mv node-$node_ver-linux-x64-static.tar.xz /workspace
