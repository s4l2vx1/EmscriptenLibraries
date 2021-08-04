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

function flags()
{
    local AdditionalCFlags=""

    if [ "${EnableShared}" == "1" ]; then
        AdditionalCFlags="-DZEXPORT=\"__attribute__((used))\""
        AdditionalFlags="-DBUILD_SHARED_LIBS=ON -DCMAKE_SHARED_LIBRARY_SUFFIX=\".wasm\""
    fi

    AdditionalFlags+=" -DCMAKE_C_FLAGS='${CFLAGS} ${AdditionalCFlags}'"
    AdditionalFlags+=" -DCMAKE_CXX_FLAGS='${CXXFLAGS} ${AdditionalCFlags}'"
    AdditionalFlags+=" -DCMAKE_SHARED_LINKER_FLAGS='${LDFLAGS}'"
}

function build() {
    flags

    if [ ! -e "${BuildDirName}" ]; then
        mkdir ${BuildDirName}
    fi

    cd ${BuildDirName}

    eval "emcmake cmake -G\"Unix Makefiles\" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_PREFIX_PATH=\"${SysRootDir}\" \
        -DCMAKE_FIND_ROOT_PATH=\"${SysRootDir}\" \
        -DCMAKE_INSTALL_PREFIX=\"${SysRootDir}\" \
        ${AdditionalFlags} .."
    
    make install -j "${MakeConcurrency}"
}
