#!/bin/bash

RepositoryName="giflib"
RepositoryAddress="https://github.com/mirrorer/giflib.git"

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
    autoreconf -ifs
    emconfigure ../configure --prefix=${SysRootDir}
    make
    make install
}

function build_wasm_pic() {
    rm -rf build_wasm_pic
    mkdir build_wasm_pic
    cd build_wasm_pic
    autoreconf -ifs
    emconfigure ../configure --prefix=${SysRootDir} CFLAGS='-fPIC' CXXFLAGS='-fPIC'
    make 
    make install
}

function build_asmjs() {
    rm -rf build_asmjs
    mkdir build_asmjs
    cd build_asmjs
    autoreconf -ifs
    emconfigure ../configure --prefix=${SysRootDir}
    make
    make install
}
