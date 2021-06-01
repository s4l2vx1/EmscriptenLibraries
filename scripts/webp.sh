#!/bin/bash

RepositoryName="libwebp"
RepositoryAddress="https://github.com/webmproject/libwebp.git"
RepositoryLicense="BSD 3-Clause License"

function init() {
    cd ${RepositoryDir}

    if [ ! -e "${RepositoryName}" ]; then
        git clone --depth 1 ${RepositoryAddress}
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
            -DCMAKE_INSTALL_PREFIX="${SysRootDir}" \
            -DWEBP_BUILD_WEBP_JS=On ..
    else
        cd ${BuildDirName}
    fi
    
    make install
}
