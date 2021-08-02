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
    local AdditionalCFlags=

    if [ "${EnableShared}" == "1" ]; then
        AdditionalCFlags="-D\"PNG_IMPEXP=__attribute__((used))\""
        AdditionalFlags="-DPNG_SHARED=ON -DPNG_STATIC=OFF -DCMAKE_SHARED_LIBRARY_SUFFIX=\".wasm\""
    else
        AdditionalFlags="-DPNG_SHARED=OFF -DPNG_STATIC=ON"
    fi

    if [ "${EnableSIMD}" == "1" ]; then
        AdditionalFlags+=" -DPNG_INTEL_SSE=On"
    else
        AdditionalFlags+=" -DPNG_INTEL_SSE=Off"
    fi

    AdditionalFlags+=" -DCMAKE_C_FLAGS='${CFLAGS} ${AdditionalCFlags}'"
    AdditionalFlags+=" -DCMAKE_CXX_FLAGS='${CXXFLAGS} ${AdditionalCFlags}'"
    AdditionalFlags+=" -DCMAKE_SHARED_LINKER_FLAGS='${LDFLAGS}'"

    echo ${AdditionalFlags}
}

function build() {
    flags

    if [ ! -e "${BuildDirName}" ]; then
        mkdir ${BuildDirName}
    fi

    cd ${BuildDirName}

    eval "emcmake cmake -G\"Unix Makefiles\" \
            -DCMAKE_BUILD_TYPE=Release \
            -DCMAKE_PREFIX_PATH=\"${SysRootDir}\" \
            -DCMAKE_FIND_ROOT_PATH=\"${SysRootDir}\" \
            -DCMAKE_INSTALL_PREFIX=\"${SysRootDir}\" \
            ${AdditionalFlags} .."
   
    make install -j "${MakeConcurrency}"
}
