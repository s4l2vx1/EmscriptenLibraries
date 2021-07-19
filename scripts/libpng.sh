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

function flags() {

    if [ "${EnableShared}" == "1" ]; then
        CFLAGS+=" -DPNG_IMPEXP='__attribute__((used))'"
        CXXFLAGS+=" -DPNG_IMPEXP='__attribute__((used))'"
        AdditionalFlags="${AdditionalFlags} -DPNG_SHARED=ON -DPNG_STATIC=OFF -DPNG_BUILD_ZLIB=ON -DCMAKE_SHARED_LIBRARY_SUFFIX=\".wasm\""
    else
        AdditionalFlags="${AdditionalFlags} -DPNG_SHARED=OFF -DPNG_STATIC=ON -DPNG_BUILD_ZLIB=ON"
    fi

    AdditionalFlags+=" -DCMAKE_C_FLAGS=\"${CFLAGS}\" -DCMAKE_CXX_FLAGS=\"${CXXFLAGS}\""
}

function build() {
    flags

    if [ ! -e "${BuildDirName}" ]; then
        mkdir ${BuildDirName}
    fi

    cd ${BuildDirName}

    eval "emcmake cmake -G\"Unix Makefiles\" \
            -DCMAKE_BUILD_TYPE=Release \
            -DPNG_SHARED=Off \
            -DCMAKE_PREFIX_PATH=\"${SysRootDir}\" \
            -DCMAKE_FIND_ROOT_PATH=\"${SysRootDir}\" \
            -DCMAKE_INSTALL_PREFIX=\"${SysRootDir}\" \
            ${AdditionalFlags} .."
   
    make install -j "${MakeConcurrency}"
}
