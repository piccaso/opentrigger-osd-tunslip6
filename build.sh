#!/bin/sh
docker run -t --rm -v`pwd`:/work $DOCKERIMAGE make ARCH=$ARCH BINTRAYAUTH=$BINTRAYAUTH DIST=$DIST clean deb publish
