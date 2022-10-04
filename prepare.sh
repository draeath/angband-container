#!/bin/bash
pushd "$(dirname -- "$( readlink -f -- "$0"; )")" > /dev/null || exit 1

# architecture
ALPINE_ARCH="x86_64" # x86_64 | aarch64
TINI_ARCH="amd64"    # amd64  | arm64

# versions
ALPINE_RELEASE="3.16"
ALPINE_FULLVER="${ALPINE_RELEASE}.2"
TINI_RELEASE="0.19.0"

if ! [ -f alpine-minirootfs.tar.gz ]; then
    curl -s -S -L "https://dl-cdn.alpinelinux.org/alpine/v${ALPINE_RELEASE}/releases/${ALPINE_ARCH}/alpine-minirootfs-${ALPINE_FULLVER}-${ALPINE_ARCH}.tar.gz" --output alpine-minirootfs.tar.gz
fi
if ! [ -f tini-static ]; then
    curl -s -S -L "https://github.com/krallin/tini/releases/download/v${TINI_RELEASE}/tini-static-${TINI_ARCH}" --output tini-static
fi
if ! [ -f angband.tar.gz ]; then
    git submodule update --init
    tar czf angband.tar.gz --owner=0 --group=0 angband
fi

popd > /dev/null || exit 1
