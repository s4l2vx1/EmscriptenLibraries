#!/bin/bash

RepositoryName="freetype"
RepositoryAddress="https://github.com/freetype/freetype.git"
RepositoryLicense="FreeType License"

function init() {
    cd ${RepositoryDir}

    if [ ! -e "${RepositoryName}" ]; then
        git clone ${RepositoryAddress}
    fi

    cd ${RepositoryName}
}

function clean() {
    rm -rf ${BuildDirName}
}

function build() {
    if [ ! -e "${BuildDirName}" ]; then
        mkdir ${BuildDirName}
        cd ${BuildDirName}

        emcmake cmake -G"Unix Makefiles" \
            -DCMAKE_BUILD_TYPE=Release \
            -DFT_WITH_ZLIB=On \
            -DFT_WITH_PNG=On \
            -DCMAKE_PREFIX_PATH="${SysRootDir}" \
            -DCMAKE_FIND_ROOT_PATH="${SysRootDir}" \
            -DCMAKE_INSTALL_PREFIX="${SysRootDir}" ..
    else
        cd ${BuildDirName}
    fi

    make install -j "${MakeConcurrency}"
}
