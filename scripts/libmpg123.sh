#!/bin/bash

RepositoryName="libmpg123"
RepositoryAddress="https://mpg123.org"
RepositoryLicense="LGPL v2.1"

RepositoryDownloadAddress="http://mpg123.org/download/mpg123-1.27.2.tar.bz2"

function download() {
    curl "${RepositoryDownloadAddress}" > libmpg123.tar.bz2
    bzip2 -d libmpg123.tar.bz2
    tar -xf libmpg123.tar
    find . -type d -name mpg123-* | xargs -I{} mv {} libmpg123
    rm libmpg123.tar
}

function init() {
    cd ${RepositoryDir}

    if [ ! -e "${RepositoryName}" ]; then
        download
    fi

    cd ${RepositoryName}
    autoreconf -ifs
}

function clean() {
    rm -rf ${BuildDirName}
}

function build() {
    if [ ! -e "${BuildDirName}" ]; then
        mkdir ${BuildDirName}
        cd ${BuildDirName}
        emconfigure ../configure --prefix=${SysRootDir} --with-cpu=generic LDFLAGS='-all-static'
    else
        cd ${BuildDirName}
    fi
    
    make install
}
