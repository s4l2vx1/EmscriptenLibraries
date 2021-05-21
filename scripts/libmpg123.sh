#!/bin/bash

RepositoryName="libmpg123"
RepositoryAddress="https://mpg123.org"
RepositoryLicense="LGPL v2.1"

RepositoryDownloadAddress="http://mpg123.org/download/mpg123-1.27.2.tar.bz2"

function init() {
    cd ${RepositoryDir}

    if [ ! -e "${RepositoryName}" ]; then
        curl "${RepositoryDownloadAddress}" > libmpg123.tar.bz2
        bzip2 -d libmpg123.tar.bz2
        tar -xf libmpg123.tar
        find . -type d -name mpg123-* | xargs -I{} mv {} libmpg123
        rm libmpg123.tar
    fi

    cd ${RepositoryName}
    autoreconf -ifs
}

function build_wasm() {
    rm -rf build_wasm
    mkdir build_wasm
    cd build_wasm
    emconfigure ../configure --prefix=${SysRootDir} --with-cpu=generic LDFLAGS='-all-static'
    make install
}

function build_wasm_pic() {
    rm -rf build_wasm_pic
    mkdir build_wasm_pic
    cd build_wasm_pic
    emconfigure ../configure --prefix=${SysRootDir} --with-cpu=generic CFLAGS='-fPIC' CXXFLAGS='-fPIC' LDFLAGS='-all-static'
    make install
}

function build_asmjs() {
    rm -rf build_asmjs
    mkdir build_asmjs
    cd build_asmjs
    emconfigure ../configure --prefix=${SysRootDir} --with-cpu=generic LDFLAGS='-all-static'
    make install
}
