#!/bin/bash

RepositoryName="soundtouch"
RepositoryAddress="https://gitlab.com/soundtouch/soundtouch.git"
RepositoryLicense="LGPL v2.1"

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
        emconfigure ../configure --prefix=${SysRootDir} enable_static=yes enable_shared=no
    else
        cd ${BuildDirName}
    fi
    
    make install
}
