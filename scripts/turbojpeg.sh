#!/bin/bash

RepositoryName="libjpeg-turbo"
RepositoryAddress="https://github.com/libjpeg-turbo/libjpeg-turbo.git"
RepositoryLicense="IJG License; Modified BSD 3-Clause License; zlib License"

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

        emcmake cmake -G"Unix Makefiles" -DCMAKE_EXECUTABLE_SUFFIX=.html \
            -DCMAKE_BUILD_TYPE=Release \
            -DWITH_SIMD=0 -DENABLE_SHARED=0 \
            -DCMAKE_PREFIX_PATH="${SysRootDir}" \
            -DCMAKE_FIND_ROOT_PATH="${SysRootDir}" \
            -DCMAKE_INSTALL_PREFIX="${SysRootDir}" \
            -DCMAKE_C_FLAGS="-Wall -s ALLOW_MEMORY_GROWTH=1" ..
    else
        cd ${BuildDirName}
    fi
    
    make install -j "${MakeConcurrency}"
}
