#!/bin/sh
docker run --rm -v`pwd`:/work $DOCKERIMAGE make ARCH=$ARCH BINTRAYAUTH=$BINTRAYAUTH clean deb publish
