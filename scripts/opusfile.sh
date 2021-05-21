#!/bin/bash

RepositoryName="opusfile"
RepositoryAddress="https://github.com/xiph/opusfile.git"
RepositoryLicense="BSD 3-Clause License"

function init() {
    cd ${RepositoryDir}

    if [ ! -e "${RepositoryName}" ]; then
        git clone --depth 1 ${RepositoryAddress}      
    fi

    cd ${RepositoryName}
    ./autogen.sh
}

function build_wasm() {
    rm -rf build_wasm
    mkdir build_wasm
    cd build_wasm
    emconfigure ../configure --prefix=${SysRootDir} --disable-shared --enable-static --disable-examples
    make install
}

function build_wasm_pic() {
    rm -rf build_wasm_pic
    mkdir build_wasm_pic
    cd build_wasm_pic
    emconfigure ../configure --prefix=${SysRootDir} CFLAGS='-fPIC' CXXFLAGS='-fPIC' --disable-shared --enable-static --disable-examples
    make install
}

function build_asmjs() {
    rm -rf build_asmjs
    mkdir build_asmjs
    cd build_asmjs
    emconfigure ../configure --prefix=${SysRootDir} --disable-shared --enable-static --disable-examples
    make install
}
