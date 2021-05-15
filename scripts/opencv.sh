#!/bin/bash

RepositoryName="opencv"
RepositoryAddress="https://github.com/opencv/opencv.git"

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

function build_wasm() {
    python ./platforms/js/build_js.py build_wasm --build_wasm --build_flags="-mno-bulk-memory -DCMAKE_INSTALL_PREFIX=${SysRootDir}"
}

function build_wasm_pic() {
    echo "Not Implemented"
    exit 1
}

function build_asmjs() {
    echo "Not Implemented"
    exit 1
}
