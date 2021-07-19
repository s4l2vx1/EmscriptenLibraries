#!/bin/bash

RepositoryName="opencv"
RepositoryAddress="https://github.com/opencv/opencv.git"
RepositoryLicense="Apache License v2.0"
EmscriptenDir="${EMSDK}/upstream/emscripten"

function init() {
    cd ${RepositoryDir}

    if [ "${EMSDK}" == "" ] && [ ! -e "${EmscriptenDir}" ]; then
        echo "Please specify emscripten install path. (see opencv.sh)"
        exit 1
    fi

    if [ ! -e "${RepositoryName}" ]; then
        git clone --depth 1 -b 4.5.1 ${RepositoryAddress}
    fi

    cd ${RepositoryName}
}

function clean() {
    rm -rf ${BuildDirName}
}

function flags() {
    AdditionalFlags="--build_flags=\"${CFLAGS}\""

    if [ "${EnableSIMD}" == "1" ]; then
        AdditionalFlags="${AdditionalFlags} --simd"
    fi

    if [ "${EnableShared}" == "1" ]; then
        AdditionalFlags="${AdditionalFlags} --cmake_option=\"-DBUILD_SHARED_LIBS=ON\" --cmake_option=\"-DOPENCV_SKIP_GC_SECTIONS=ON\" --cmake_option=\"-DENABLE_PIC=TRUE\""
    else
        AdditionalFlags="${AdditionalFlags} --cmake_option=\"-DBUILD_SHARED_LIBS=OFF\""
    fi
}

function build() {
    flags

    eval "python3 ./platforms/js/build_js.py ${BuildDirName} \
        --build_wasm \
        --cmake_option=\"-DCMAKE_INSTALL_PREFIX=${SysRootDir}\" \
        --cmake_option=\"-DOPENCV_GENERATE_PKGCONFIG=ON\" \
        --cmake_option=\"-DCMAKE_SHARED_LIBRARY_SUFFIX=.wasm\" \
        --emscripten_dir=\"${EmscriptenDir}\" \
        ${AdditionalFlags}"
        
    cd ${BuildDirName}
    make install
}
