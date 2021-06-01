#!/bin/bash

RepositoryName="harfbuzz"
RepositoryAddress="https://github.com/harfbuzz/harfbuzz.git"
RepositoryLicense="MIT License"

function init() {
    cd ${RepositoryDir}

    if [ ! -e "${RepositoryName}" ]; then
        git clone --depth 1 ${RepositoryAddress}
    fi

    cd ${RepositoryName}
}

function build_wasm() {
    rm -rf build_wasm
    mkdir build_wasm
    cd build_wasm
    emcmake cmake -G"Unix Makefiles" \
        -DCMAKE_BUILD_TYPE=Release \
        -DHB_HAVE_FREETYPE=On \
        -DCMAKE_PREFIX_PATH="${SysRootDir}" \
        -DCMAKE_FIND_ROOT_PATH="${SysRootDir}" \
        -DCMAKE_INSTALL_PREFIX="${SysRootDir}" ..
    make install
}

function build_wasm_pic() {
    rm -rf build_wasm_pic
    mkdir build_wasm_pic
    cd build_wasm_pic
    emcmake cmake -G"Unix Makefiles" \
        -DCMAKE_BUILD_TYPE=Release \
        -DHB_HAVE_FREETYPE=On \
        -DCMAKE_PREFIX_PATH="${SysRootDir}" \
        -DCMAKE_FIND_ROOT_PATH="${SysRootDir}" \
        -DCMAKE_INSTALL_PREFIX="${SysRootDir}" \
        -DCMAKE_C_FLAGS="-s SIDE_MODULE=1" -DCMAKE_CXX_FLAGS="-s SIDE_MODULE=1" ..
    make install
}

function build_asmjs() {
    rm -rf build_asmjs
    mkdir build_asmjs
    cd build_asmjs
    emcmake cmake -G"Unix Makefiles" \
        -DCMAKE_BUILD_TYPE=Release \
        -DHB_HAVE_FREETYPE=On \
        -DCMAKE_PREFIX_PATH="${SysRootDir}" \
        -DCMAKE_FIND_ROOT_PATH="${SysRootDir}" \
        -DCMAKE_INSTALL_PREFIX="${SysRootDir}" ..
    make install
}
