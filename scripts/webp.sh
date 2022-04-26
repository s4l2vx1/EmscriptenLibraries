#!/bin/bash

RepositoryName="libwebp"
RepositoryAddress="https://github.com/webmproject/libwebp.git"
RepositoryLicense="BSD 3-Clause License"

function init() {
    cd ${RepositoryDir}

    if [ ! -e "${RepositoryName}" ]; then
        git clone --depth 1 ${RepositoryAddress}
    fi

    cd ${RepositoryName}
}

function clean() {
    rm -rf ${BuildDirName}
}

function flags()
{
    local AdditionalCFlags=""
    local AdditionalLDFlags="-s ERROR_ON_UNDEFINED_SYMBOLS=0 -Wl,--allow-undefined"
    AdditionalFlags="-DWEBP_BUILD_ANIM_UTILS=OFF -DWEBP_BUILD_CWEBP=OFF -DWEBP_BUILD_DWEBP=OFF"
    AdditionalFlags+=" -DWEBP_BUILD_GIF2WEBP=OFF -DWEBP_BUILD_IMG2WEBP=OFF -DWEBP_BUILD_VWEBP=OFF"
    AdditionalFlags+=" -DWEBP_BUILD_WEBPINFO=OFF -DWEBP_BUILD_WEBPMUX=OFF -DWEBP_BUILD_EXTRAS=OFF"

    if [ ! -z ${WASI+x} ]; then
        AdditionalCFlags="-DPNG_NO_SETJMP_SUPPORTED"
    fi

    if [ "${EnableShared}" == "1" ]; then
        AdditionalCFlags+=" -DWEBP_EXTERN=\"extern __attribute__((used))\""
        AdditionalFlags=" -DBUILD_SHARED_LIBS=ON -DCMAKE_SHARED_LIBRARY_SUFFIX=\".wasm\""      
    else
        AdditionalCFlags+=" -DWEBP_EXTERN=\"extern\""
        AdditionalFlags=" -DBUILD_SHARED_LIBS=OFF"
    fi

    if [ "${EnableSIMD}" == "1" ]; then
        AdditionalFlags+=" -DWEBP_ENABLE_SIMD=ON"      
    else
        AdditionalFlags+=" -DWEBP_ENABLE_SIMD=OFF"
    fi

    if [ "${EnableThreads}" == "1" ]; then
        AdditionalFlags+=" -DWEBP_USE_THREAD=ON"      
    else
        AdditionalFlags+=" -DWEBP_USE_THREAD=OFF"
    fi

    AdditionalFlags+=" -DCMAKE_C_FLAGS='${CFLAGS} ${AdditionalCFlags}'"
    AdditionalFlags+=" -DCMAKE_CXX_FLAGS='${CXXFLAGS} ${AdditionalCFlags}'"
    AdditionalFlags+=" -DCMAKE_SHARED_LINKER_FLAGS='${LDFLAGS} ${AdditionalLDFlags}'"
    AdditionalFlags+=" -DCMAKE_EXE_LINKER_FLAGS='${LDFLAGS} ${AdditionalLDFlags}'"
}

function build() {
    flags

    if [ ! -e "${BuildDirName}" ]; then
        mkdir ${BuildDirName}
        cd ${BuildDirName}
    fi

    cd ${BuildDirName}

    eval "${CMakeCommand} -G\"Unix Makefiles\" \
            -DCMAKE_BUILD_TYPE=Release \
            -DCMAKE_PREFIX_PATH=\"${SysRootDir}\" \
            -DCMAKE_FIND_ROOT_PATH=\"${SysRootDir}\" \
            -DCMAKE_INSTALL_PREFIX=\"${SysRootDir}\" \
            ${AdditionalFlags} .."
    
    make install -j "${MakeConcurrency}"
}
