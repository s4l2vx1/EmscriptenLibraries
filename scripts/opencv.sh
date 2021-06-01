#!/bin/bash

RepositoryName="opencv"
RepositoryAddress="https://github.com/opencv/opencv.git"
RepositoryLicense="Apache License v2.0"
EmscriptenDir="${EMSDK}/upstream/emscripten"

function init() {
    cd ${RepositoryDir}

    echo "emlib: opencv: TODO: Search EmscriptenDir"

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

function build() {
    python3 ./platforms/js/build_js.py ${BuildDirName} \
        --build_wasm \
        --cmake_option="-DCMAKE_INSTALL_PREFIX=${SysRootDir}" \
        --cmake_option="-DOPENCV_GENERATE_PKGCONFIG=ON" \
        --build_flags="-mno-bulk-memory" \
        --emscripten_dir="${EmscriptenDir}"
        
    cd ${BuildDirName}
    make install
}
