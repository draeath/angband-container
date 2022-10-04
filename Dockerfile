FROM scratch AS base
ADD alpine-minirootfs.tar.gz /
COPY --chown=0:0 tini-static /bin/tini
RUN /bin/chmod 0555 /bin/tini
CMD ["/bin/sh"]
ENTRYPOINT ["/bin/tini", "--"]
WORKDIR /root

FROM base AS build
RUN apk update && apk add build-base clang lld make automake autoconf ncurses-dev sqlite-dev
ADD angband.tar.gz /usr/src/
WORKDIR /usr/src/angband
RUN ./autogen.sh && \
    CC=clang CPP=clang-cpp CXX=clang++ CFLAGS='-pipe' CXXFLAGS='-pipe' LDFLAGS='-fuse-ld=lld' ./configure \
        --prefix=/opt/angband \
        --bindir=/opt/angband/bin \
        --disable-x11 --disable-win --disable-test \
        --disable-sdl --disable-sdl-mixer --disable-sdltest \
        --disable-sdl2 --disable-sdl2-mixer --disable-sdl2test \
        --enable-stats \
        --enable-spoil \
        --enable-release && \
    make -j$(nproc) && strip --strip-unneeded src/angband && make -j$(nproc) install

FROM base
RUN apk update && apk add ncurses-libs sqlite-libs
COPY --from=build /opt/angband /opt/angband
RUN ln -sv /opt/angband/bin/angband /bin/angband
CMD ["/bin/angband"]
