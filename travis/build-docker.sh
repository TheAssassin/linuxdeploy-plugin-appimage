#! /bin/bash

set -xe

old_cwd=$(readlink -f .)
here=$(readlink -f $(dirname "$0"))

DOCKERFILE="$here"/Dockerfile
IMAGE=linuxdeploy-plugin-appimage-build

if [ "$ARCH" == "i386" ]; then
    DOCKERFILE="$DOCKERFILE".i386
    IMAGE="$IMAGE".i386
fi

(cd "$here" && docker build -f "$DOCKERFILE" -t "$IMAGE" .)

docker run --rm -i -v "$here"/..:/ws:ro -v "$old_cwd":/out -e CI=1 -e OUTDIR_OWNER=$(id -u) "$IMAGE" /bin/bash -xe /ws/travis/build-appimage.sh
