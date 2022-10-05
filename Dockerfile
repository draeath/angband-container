FROM alpine:3 AS build
RUN apk --no-cache add build-base clang lld make automake autoconf ncurses-dev
COPY --chown=0:0 angband /usr/src/angband
WORKDIR /usr/src/angband
RUN ./autogen.sh && \
    CC=clang CPP=clang-cpp CXX=clang++ LDFLAGS='-fuse-ld=lld' ./configure \
        --prefix=/opt/angband \
        --disable-test --disable-stats --disable-spoil --disable-x11 --disable-win \
        --disable-sdl --disable-sdl-mixer --disable-sdltest \
        --disable-sdl2 --disable-sdl2-mixer --disable-sdl2test \
        --enable-curses --enable-release --enable-skip-old-int-typedefs && \
    make -j$(nproc) && strip --strip-unneeded src/angband && make -j$(nproc) install && \
    rm -Rf /opt/angband/share/angband/tiles /opt/angband/share/angband/sounds /opt/angband/share/angband/icons

FROM alpine:3 AS runtime
RUN apk --no-cache add ncurses-libs
COPY --from=build /opt/angband /opt/angband
ENTRYPOINT ["/opt/angband/games/angband"]
