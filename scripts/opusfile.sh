#!/bin/bash

RepositoryName="opusfile"
RepositoryAddress="https://github.com/xiph/opusfile.git"
RepositoryLicense="BSD 3-Clause License"

function init() {
    cd ${RepositoryDir}

    if [ ! -e "${RepositoryName}" ]; then
        git clone --depth 1 -b v0.12 ${RepositoryAddress}  

        cd ${RepositoryName}
        ./autogen.sh
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
        AdditionalLDFlags+=" -Wc,-sSIDE_MODULE=1"    
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

    CFLAGS="${AdditionalCFlags}" LDFLAGS="${AdditionalLDFlags}" eval "emconfigure ../configure --prefix=${SysRootDir} ${AdditionalFlags} --host x86-unknown-linux --disable-examples --enable-http=no"
    CFLAGS="${AdditionalCFlags}" LDFLAGS="${AdditionalLDFlags}" make install -j "${MakeConcurrency}"
}
