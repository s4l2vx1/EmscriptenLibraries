#!/bin/bash

RepositoryName="giflib"
RepositoryAddress="https://github.com/mirrorer/giflib.git"
RepositoryLicense="MIT License"

function init() {
    cd ${RepositoryDir}

    if [ ! -e "${RepositoryName}" ]; then
        git clone --depth 1 ${RepositoryAddress}

        cd ${RepositoryName}
        autoreconf -ifs
    else
        cd ${RepositoryName}
    fi
}

function clean() {
    rm -rf ${BuildDirName}
}

function build() {
    if [ ! -e "${BuildDirName}" ]; then
        mkdir ${BuildDirName}
        cd ${BuildDirName}
        emconfigure ../configure enable_static=yes enable_shared=no --host x86 --prefix=${SysRootDir}
    else
        cd ${BuildDirName}
    fi
    
    make install -j "${MakeConcurrency}"
}
