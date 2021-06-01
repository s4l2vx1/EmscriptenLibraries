#!/bin/bash

RepositoryName="opusfile"
RepositoryAddress="https://github.com/xiph/opusfile.git"
RepositoryLicense="BSD 3-Clause License"

function init() {
    cd ${RepositoryDir}

    if [ ! -e "${RepositoryName}" ]; then
        git clone --depth 1 ${RepositoryAddress}  

        cd ${RepositoryName}
        ./autogen.sh
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
        emconfigure ../configure --prefix=${SysRootDir} --disable-shared --enable-static --disable-examples
    else
        cd ${BuildDirName}
    fi
    
    make install
}
