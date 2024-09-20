# `node-static`

Highly opinionated x86_64-linux nodejs build, fully statically linked,
with increased V8 wasm limits, pointer compression and mimalloc.
Should be fast when it works, but it doesn't work with native addons,
so don't use it in your project unless you know what you're doing.
