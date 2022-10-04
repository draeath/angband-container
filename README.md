This is just a silly practice exercise in doing things in containers.

Specifically this builds [Angband](https://github.com/angband/angband/blob/master/README.md) in Alpine without using any dockerhub images. It uses the minroot Alpine download to populate a "from scratch" base container.

- if you aren't running 64-bit X86, edit `prepare.sh` as appropriate to grab the correct minroot alpine image and tini binary.
- if you need to change the angband submodule from the [4.2-release branch](https://github.com/angband/angband/tree/4.2-release) to a different branch, tag, or commit... [do that first.](https://git-scm.com/docs/git-submodule)
- run `prepare.sh` to download the alpine minroot image, tini, and init/update the angband submodule.
- build the container, ie `podman build -t angband --squash .`
- optionally clean up the `*.tar.gz` and `tini-static` files and build cache.

The end result should be a small-ish (< 100mb) container with the game in it, ready for you to play. Of course, only the text (ncurses) mode is available, because the logistics of getting X11 or SDL passed through the container to the host is not something I wish to mess with. Note that stats and spoiler frontend/backends are available. The entrypoint/cmd is set so if you don't specify something different, it'll run the game.

If you want persistence, you should use a volume or bindmount `/root/.angband/` somewhere.

- `podman run --rm -it -v ~/.angband:/root/.angband:rw localhost/angband:latest`
