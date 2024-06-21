#!/bin/bash

RepositoryName="giflib-code"
RepositoryAddress="https://git.code.sf.net/p/giflib/code giflib-code"
RepositoryLicense="MIT License"

function init() {
    cd ${RepositoryDir}

    if [ ! -e "${RepositoryName}" ]; then
        git clone --depth 1 -b 5.2.1 ${RepositoryAddress}

        cd ${RepositoryName}
        autoreconf -ifs
    else
        cd ${RepositoryName}
    fi
}

function clean() {
    rm -rf ${BuildDirName}
}

function flags()
{
    AdditionalCFlags="${CFLAGS}"
    AdditionalLDFlags="${LDFLAGS}"

    if [ "${EnableShared}" == "1" ]; then
        AdditionalFlags="--enable-shared"
    else
        AdditionalFlags="--enable-static"
    fi
}

function build() {
    flags

    if [ ! -e "${BuildDirName}" ]; then
        mkdir ${BuildDirName}
    fi
    
    cd ${BuildDirName}
    
    CFLAGS="${AdditionalCFlags}" LDFLAGS="${AdditionalLDFlags}" eval "emconfigure ../configure ${AdditionalFlags} --host x86-unknown-linux --prefix=${SysRootDir}"
    
    CFLAGS="${AdditionalCFlags}" LDFLAGS="${AdditionalLDFlags}" make install -j "${MakeConcurrency}"
}
