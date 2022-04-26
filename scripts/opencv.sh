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
    local AdditionalCFlags=""
    local AdditionalLDFlags=""
    AdditionalFlags=""

    if [ "${EnableSIMD}" == "1" ]; then
        AdditionalFlags+="--simd"
    fi

    if [ "${EnableShared}" == "1" ]; then
        AdditionalCFlags+="-s SIDE_MODULE=1"
        AdditionalFlags+=" --cmake_option=\"-DBUILD_SHARED_LIBS=ON\" --cmake_option=\"-DOPENCV_SKIP_GC_SECTIONS=ON\" --cmake_option=\"-DENABLE_PIC=TRUE\""
    else
        AdditionalCFlags+="${CFLAGS}"
        AdditionalFlags+=" --cmake_option=\"-DBUILD_SHARED_LIBS=OFF\""
    fi

    AdditionalFlags+=" --build_flags=\"${AdditionalCFlags}\""
    AdditionalFlags+=" --cmake_option=\"-DCMAKE_SHARED_LINKER_FLAGS='${AdditionalLDFlags}'\""
}

function build() {
    flags

    eval "python3 ./platforms/js/build_js.py ${BuildDirName} \
        --build_wasm \
        --cmake_option=\"-DCMAKE_INSTALL_PREFIX=${SysRootDir}\" \
        --cmake_option=\"-DCMAKE_PREFIX_PATH=${SysRootDir}\" \
        --cmake_option=\"-DCMAKE_FIND_ROOT_PATH=${SysRootDir}\" \
        --cmake_option=\"-DOPENCV_GENERATE_PKGCONFIG=ON\" \
        --cmake_option=\"-DCMAKE_SHARED_LIBRARY_SUFFIX=.wasm\" \
        --emscripten_dir=\"${EmscriptenDir}\" \
        ${AdditionalFlags}"
        
    cd ${BuildDirName}
    make install
}
