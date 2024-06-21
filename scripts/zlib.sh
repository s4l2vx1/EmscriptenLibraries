#!/bin/bash

RepositoryName="zlib"
RepositoryAddress="https://github.com/madler/zlib"
RepositoryLicense="zlib License"

function init() {
    cd ${RepositoryDir}

    if [ ! -e "${RepositoryName}" ]; then
        git clone --depth 1 -b v1.2.13  ${RepositoryAddress}
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

    eval "${CMakeCommand} -G\"Unix Makefiles\" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_PREFIX_PATH=\"${SysRootDir}\" \
        -DCMAKE_FIND_ROOT_PATH=\"${SysRootDir}\" \
        -DCMAKE_INSTALL_PREFIX=\"${SysRootDir}\" \
        ${AdditionalFlags} .."
    
    make install -j "${MakeConcurrency}"
}
