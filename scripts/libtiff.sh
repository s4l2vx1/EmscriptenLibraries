#!/bin/bash

RepositoryName="libtiff"
RepositoryAddress="https://gitlab.com/libtiff/libtiff.git"
RepositoryLicense="MIT License"

function init() {
    cd ${RepositoryDir}

    if [ ! -e "${RepositoryName}" ]; then
        git clone --depth 1 ${RepositoryAddress}
        # FIXME: 
        sed -i -e 's/check_type_size("size_t" SIZEOF_SIZE_T)/set(SIZEOF_SIZE_T 8)/g' "libtiff/cmake/TypeSizeChecks.cmake"
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
            -DCMAKE_PREFIX_PATH="${SysRootDir}" \
            -DCMAKE_FIND_ROOT_PATH="${SysRootDir}" \
            -DCMAKE_INSTALL_PREFIX="${SysRootDir}" ..
    else
        cd ${BuildDirName}
    fi
    
    make install -j "${MakeConcurrency}"
}
