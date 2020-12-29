# Lwan + Lua Stem

Lwan is a high-performance & scalable web server.[\*](https://lwan.ws/)

## Build

This build includes:

  * [Lwan](https://github.com/lpereira/lwan)
  * [LuaJIT](https://github.com/LuaJIT/LuaJIT)
  * [Brotli](https://github.com/google/brotli)
  * [Zstandard](https://github.com/facebook/zstd)
  * [jemalloc](https://github.com/jemalloc/jemalloc)

## Deploy

Deploy with [Docker](https://www.docker.com/) using embedded [ops-docker](https://github.com/ops-tools/ops-docker) tool.

Scripts available:

  * `scripts/start` for starting local instance
  * `scripts/rollout` for rolling out to remote hosts
  * `scripts/rollback` for rolling back at once


## License

[The Unlicense](LICENSE).
