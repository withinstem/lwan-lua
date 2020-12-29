# Builder

FROM debian:bullseye-20201209-slim AS builder

ARG LWAN_VERSION=master
ARG LUAJIT_VERSION=v2.0
ARG BROTLI_VERSION=v1.0.7
ARG ZSTD_VERSION=v1.4.8
ARG JEMALLOC_VERSION=5.2.1

WORKDIR /usr/local/src

## Build dependencies
RUN apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates git gcc libc6-dev zlib1g-dev autoconf pkgconf make cmake

## jemalloc
RUN git clone https://github.com/jemalloc/jemalloc.git && \
    cd jemalloc && \
    git checkout "${JEMALLOC_VERSION}" && \
    ./autogen.sh && \
    make && \
    make install PREFIX=/usr/local

## Zstandard
RUN git clone https://github.com/facebook/zstd.git && \
    cd zstd && \
    git checkout "${ZSTD_VERSION}" && \
    make && \
    make install PREFIX=/usr/local

## Brotli
RUN git clone https://github.com/google/brotli.git && \
    cd brotli && \
    git checkout "${BROTLI_VERSION}" && \
    mkdir out && cd out && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local .. && \
    cmake --build . --config Release --target install

## LuaJIT
RUN git clone https://luajit.org/git/luajit-2.0.git && \
    cd luajit-2.0 && \
    git checkout "${LUAJIT_VERSION}" && \
    make && \
    make install PREFIX=/usr/local

## Lwan
RUN git clone https://github.com/lpereira/lwan.git && \
    cd lwan && \
    git checkout "${LWAN_VERSION}" && \
    mkdir build && cd build && \
    ldconfig && \
    cmake -DCMAKE_BUILD_TYPE=Release -DUSE_ALTERNATIVE_MALLOC=jemalloc -DCMAKE_INSTALL_PREFIX=/usr/local .. && \
    cmake --build . --config Release --target install

# Runtime

FROM debian:bullseye-20201209-slim

COPY --from=builder /usr/local/bin/ /usr/bin/
COPY --from=builder /usr/local/lib/ /usr/lib/

RUN ldconfig

COPY --chown=nobody:nogroup wwwroot/ /var/lwan/wwwroot/
COPY lwan/ /etc/lwan/

USER nobody

WORKDIR /etc/lwan

CMD ["lwan", "-c", "/etc/lwan/lwan.conf"]
