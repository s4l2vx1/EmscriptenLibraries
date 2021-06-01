#!/bin/bash

RepositoryName="libpng"
RepositoryAddress="http://www.libpng.org/pub/png/libpng.html"
RepositoryLicense="libpng License"

RepositoryDownloadAddress="http://prdownloads.sourceforge.net/libpng/libpng-1.6.37.tar.gz?download"

function init() {
    cd ${RepositoryDir}

    if [ ! -e "${RepositoryName}" ]; then
        curl -L "${RepositoryDownloadAddress}" > libpng.tar.gz
        gzip -d libpng.tar.gz
        tar -xf libpng.tar
        find . -type d -name libpng-* | xargs -I{} mv {} libpng
        rm libpng.tar

        sed -ie "s/if(UNIX AND NOT APPLE AND NOT BEOS AND NOT HAIKU)/if(UNIX AND NOT APPLE AND NOT BEOS AND NOT HAIKU AND NOT EMSCRIPTEN)/g" ${RepositoryName}/CMakeLists.txt
    fi

    cd ${RepositoryName}
}

function clean() {
    rm -rf ${BuildDirName}
}

function build() {
    if [ ! -e "${BuildDirName}" ]; then
        mkdir ${BuildDirName}
        cd ${BuildDirName}
        
        emcmake cmake -G"Unix Makefiles" \
            -DCMAKE_BUILD_TYPE=Release \
            -DPNG_SHARED=Off \
            -DCMAKE_PREFIX_PATH="${SysRootDir}" \
            -DCMAKE_FIND_ROOT_PATH="${SysRootDir}" \
            -DCMAKE_INSTALL_PREFIX="${SysRootDir}" ..
    else
        cd ${BuildDirName}
    fi
   
    make install -j "${MakeConcurrency}"
}
