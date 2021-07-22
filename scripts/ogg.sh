#!/bin/bash

RepositoryName="ogg"
RepositoryAddress="https://github.com/xiph/ogg.git"
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

function flags()
{
    local AdditionalCFlags="-s ALLOW_MEMORY_GROWTH=1"
    local AdditionalLDFlags=""

    if [ "${EnableShared}" == "1" ]; then
        AdditionalFlags="-DBUILD_SHARED_LIBS=On -DCMAKE_SHARED_LIBRARY_SUFFIX=\".wasm\""      
        AdditionalLDFlags="-s SIDE_MODULE=1"
    else
        AdditionalFlags="-DBUILD_SHARED_LIBS=Off"
    fi

    AdditionalFlags+=" -DCMAKE_C_FLAGS='${CFLAGS} ${AdditionalCFlags}'"
    AdditionalFlags+=" -DCMAKE_CXX_FLAGS='${CXXFLAGS} ${AdditionalCFlags}'"
    AdditionalFlags+=" -DCMAKE_SHARED_LINKER_FLAGS='${AdditionalLDFlags}'"
}

function build() {
    flags

    if [ ! -e "${BuildDirName}" ]; then
        mkdir ${BuildDirName}
    fi

    cd ${BuildDirName}
   
    eval "emcmake cmake -G\"Unix Makefiles\" \
            -DCMAKE_BUILD_TYPE=Release \
            -DINSTALL_PKG_CONFIG_MODULE=On \
            -DCMAKE_PREFIX_PATH=\"${SysRootDir}\" \
            -DCMAKE_FIND_ROOT_PATH=\"${SysRootDir}\" \
            -DCMAKE_INSTALL_PREFIX=\"${SysRootDir}\" \
            ${AdditionalFlags} .."

    make install -j "${MakeConcurrency}"
}
