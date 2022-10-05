This is just a silly practice exercise in doing things in containers. I dropped some of the stuff I'm doing and it's now built to be small, though without trying to compile with -Os or ripping out files from the game.

Specifically this builds [Angband](https://github.com/angband/angband/blob/master/README.md) in Alpine, then copies it to a clean alpine container.

- if you need to change the angband submodule from the [4.2-release branch](https://github.com/angband/angband/tree/4.2-release) to a different branch, tag, or commit... [do that first.](https://git-scm.com/docs/git-submodule)
- run `git submodule update --init` to check out the appropriate angband source.
- build the container, ie `podman build -t angband --squash .`
- optionally clean up the build cache.

The end result should be a small-ish (< 10mb) container with the game in it, ready for you to play. Of course, only the text (ncurses) mode is available, because the logistics of getting X11 or SDL passed through the container to the host is not something I wish to mess with. Additional arguments are passed to angband. Note that tiles, sounds, the desktop support (icons, etc) stuff has been ripped out to reduce footprint as they are useless in this kind of build anyway.

If you want persistence, you should use a volume or bindmount for `/root/.angband`

- `podman run --rm -it -v ~/.angband:/root/.angband:rw angband`
