#!/bin/bash

RepositoryName="zlib"
RepositoryAddress="https://zlib.net/"
RepositoryLicense="zlib License"

RepositoryDownloadAddress="https://zlib.net/zlib-1.2.11.tar.gz"

function init() {
    cd ${RepositoryDir}

    if [ ! -e "${RepositoryName}" ]; then
        curl "${RepositoryDownloadAddress}" > zlib.tar.gz
        gzip -d zlib.tar.gz
        tar -xf zlib.tar
        find . -type d -name zlib-* | xargs -I{} mv {} zlib
        rm zlib.tar
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
            -DCMAKE_PREFIX_PATH="${SysRootDir}" \
            -DCMAKE_FIND_ROOT_PATH="${SysRootDir}" \
            -DCMAKE_INSTALL_PREFIX="${SysRootDir}" ..
    else
        cd ${BuildDirName}
    fi
    
    make install
}
