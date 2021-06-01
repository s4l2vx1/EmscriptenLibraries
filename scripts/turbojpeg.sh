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

function build_wasm() {
    rm -rf build_wasm
    mkdir build_wasm
    cd build_wasm
    emcmake cmake -G"Unix Makefiles" -DCMAKE_EXECUTABLE_SUFFIX=.html \
        -DCMAKE_BUILD_TYPE=Release \
        -DWITH_SIMD=0 -DENABLE_SHARED=0 \
        -DCMAKE_PREFIX_PATH="${SysRootDir}" \
        -DCMAKE_FIND_ROOT_PATH="${SysRootDir}" \
        -DCMAKE_INSTALL_PREFIX="${SysRootDir}" \
        -DCMAKE_C_FLAGS="-Wall -s ALLOW_MEMORY_GROWTH=1" ..
    make install
}

function build_wasm_pic() {
    rm -rf build_wasm_pic
    mkdir build_wasm_pic
    cd build_wasm_pic
    emcmake cmake -G"Unix Makefiles" -DCMAKE_EXECUTABLE_SUFFIX=.html \
        -DCMAKE_BUILD_TYPE=Release \
        -DWITH_SIMD=0 -DENABLE_SHARED=0 \
        -DCMAKE_PREFIX_PATH="${SysRootDir}" \
        -DCMAKE_FIND_ROOT_PATH="${SysRootDir}" \
        -DCMAKE_INSTALL_PREFIX="${SysRootDir}" \
        -DCMAKE_C_FLAGS="-Wall -s ALLOW_MEMORY_GROWTH=1" ..
    make install
}

function build_asmjs() {
    rm -rf build_asmjs
    mkdir build_asmjs
    cd build_asmjs
    emcmake cmake -G"Unix Makefiles" -DCMAKE_EXECUTABLE_SUFFIX=.html \
        -DCMAKE_BUILD_TYPE=Release \
        -DWITH_SIMD=0 -DENABLE_SHARED=0 \
        -DCMAKE_PREFIX_PATH="${SysRootDir}" \
        -DCMAKE_FIND_ROOT_PATH="${SysRootDir}" \
        -DCMAKE_INSTALL_PREFIX="${SysRootDir}" \
        -DCMAKE_C_FLAGS="-Wall -s ALLOW_MEMORY_GROWTH=1" ..
    make install
}
