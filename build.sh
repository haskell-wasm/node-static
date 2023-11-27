#!/bin/sh

set -eu

node_ver=21.2.0

apk add \
  clang \
  linux-headers \
  lld \
  llvm \
  python3 \
  xz

cd "$(mktemp -d)"

curl -f -L --retry 5 https://github.com/nodejs/node/archive/refs/tags/v$node_ver.tar.gz | tar xz --strip-components=1
curl -f -L --retry 5 https://github.com/nodejs/node/commit/0ee49c8620793ec09bc9b8303a1915d289975fb3.diff | patch -p1
curl -f -L --retry 5 https://github.com/nodejs/node/commit/09f4aa948918bb43a45a29d89515f568336b4531.diff | patch -p1
curl -f -L --retry 5 https://github.com/nodejs/node/commit/ec023a7a793f2e2e457e811e4c6ab9e81d5feeb0.diff | patch -p1
curl -f -L --retry 5 https://github.com/nodejs/node/commit/8e60189585dce0327eca38aef8e72ed5d58e7b6f.diff | patch -p1
patch -p1 -i /workspace/node-clang-lto.diff

make -j"$(nproc)" binary \
  AR="llvm-ar" \
  CC="clang" \
  CXX="clang++" \
  CONFIG_FLAGS="--enable-lto --experimental-enable-pointer-compression --fully-static --openssl-use-def-ca-store" \
  VARIATION="static"

out/Release/node -e 'console.log(6*7)' | grep -F 42

mv node-v$node_ver-linux-x64-static.tar.xz /workspace
