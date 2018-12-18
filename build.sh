#!/bin/sh
set -e
set -u

if [ -f ./build/che-editor-plugin.tar.gz ]; then
    rm -rf ./build
fi

cd etc
mkdir -p ../build
tar zcf ../build/che-editor-plugin.tar.gz .

