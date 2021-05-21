#!/bin/bash

RepositoryName="openssl"
RepositoryAddress="https://github.com/openssl/openssl.git"
RepositoryLicense="Apache License v2.0"

function init() {
    cd ${RepositoryDir}

    if [ ! -e "${RepositoryName}" ]; then
        git clone --depth 1 ${RepositoryAddress}
    fi

    cd ${RepositoryName}
    chmod +x Configure
}

function build_wasm() {
    rm -rf build_wasm
    mkdir build_wasm
    cd build_wasm
    emconfigure ../Configure --prefix=${SysRootDir} -static no-asm no-threads no-shared no-pic
    sed -ie "/CROSS_COMPILE=/c CROSS_COMPILE=" Makefile
    make
    make install
}

function build_wasm_pic() {
    rm -rf build_wasm_pic
    mkdir build_wasm_pic
    cd build_wasm_pic
    emconfigure ../configure --prefix=${SysRootDir} CFLAGS='-fPIC' CXXFLAGS='-fPIC'
    make 
    make install
}

function build_asmjs() {
    rm -rf build_asmjs
    mkdir build_asmjs
    cd build_asmjs
    emconfigure ../configure --prefix=${SysRootDir}
    make
    make install
}
