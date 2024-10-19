#!/bin/sh

set -eu

node_ver=v23.0.0

apk add --no-interactive \
  base-cross-aarch64 \
  bsdtar \
  chimerautils-extra \
  curl \
  gmake \
  libatomic-chimera-cross-aarch64-static \
  libatomic-chimera-devel-static \
  libcxx-cross-aarch64-static \
  libcxx-devel-static \
  libcxxabi-cross-aarch64-static \
  libcxxabi-devel-static \
  libunwind-cross-aarch64-static \
  libunwind-devel-static \
  linux-headers \
  linux-headers-cross-aarch64 \
  musl-cross-aarch64-static \
  musl-devel-static \
  python

cd "$(mktemp -d)"

curl -f -L --retry 5 https://nodejs.org/dist/$node_ver/node-$node_ver.tar.xz | tar xJ --strip-components=1
patch -p1 -i /workspace/bump-v8-wasm-limits.diff
patch -p1 -i /workspace/use-etc-ssl-certs.diff

CC=aarch64-chimera-linux-musl-clang CXX=aarch64-chimera-linux-musl-clang++ CC_host=clang CXX_host=clang++ gmake -j"$(nproc)" binary \
  CONFIG_FLAGS="--dest-cpu=arm64 --fully-static --openssl-use-def-ca-store --v8-disable-maglev" \
  VARIATION="static"

mv node-$node_ver-linux-x64-static.tar.xz /workspace
