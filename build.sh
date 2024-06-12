#!/bin/sh

set -eu

node_ver=v22.3.0

apk add \
  linux-headers \
  python3 \
  xz

cd "$(mktemp -d)"

curl -f -L --retry 5 https://nodejs.org/dist/$node_ver/node-$node_ver.tar.xz | tar xJ --strip-components=1
patch -p1 -i /workspace/use-etc-ssl-certs.patch

make -j"$(nproc)" binary \
  CONFIG_FLAGS="--experimental-enable-pointer-compression --fully-static --openssl-use-def-ca-store" \
  VARIATION="static"

mv node-$node_ver-linux-x64-static.tar.xz /workspace
