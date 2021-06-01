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

function clean() {
    rm -rf ${BuildDirName}
}

function build() {
    if [ ! -e "${BuildDirName}" ]; then
        mkdir ${BuildDirName}
        cd ${BuildDirName}
        emconfigure ../Configure --prefix=${SysRootDir} -static no-asm no-threads no-shared no-pic
        sed -ie "/CROSS_COMPILE=/c CROSS_COMPILE=" Makefile
    else
        cd ${BuildDirName}
    fi
    
    make install -j "${MakeConcurrency}"
}
