#!/bin/bash

RepositoryName="libjpeg-turbo"
RepositoryAddress="https://github.com/libjpeg-turbo/libjpeg-turbo.git"
RepositoryLicense="IJG License; Modified BSD 3-Clause License; zlib License"

function init() {
    cd ${RepositoryDir}

    if [ ! -e "${RepositoryName}" ]; then
        git clone --depth 1 -b 2.1.0 ${RepositoryAddress}
        sed -i -e "s/#else/#elif !defined(DLLEXPORT)/g" ${RepositoryName}/turbojpeg.h  
    fi

    cd ${RepositoryName}
}

function clean() {
    rm -rf ${BuildDirName}
}

function flags()
{
    local AdditionalCFlags="-sALLOW_MEMORY_GROWTH=1 -DUSE_CLZ_INTRINSIC=1"
    local AdditionalLDFlags=""

    if [ "${EnableShared}" == "1" ]; then
        AdditionalCFlags+=" -DDLLEXPORT=\"__attribute__((used))\""
        AdditionalFlags="-DENABLE_SHARED=1 -DCMAKE_SHARED_LIBRARY_SUFFIX=\".wasm\""      
    else
        AdditionalFlags="-DENABLE_SHARED=0"
    fi

    if [ "${EnableSIMD}" == "1" ]; then
        AdditionalFlags+=" -DWITH_SIMD=1"      
    else
        AdditionalFlags+=" -DWITH_SIMD=0"
    fi

    AdditionalFlags+=" -DCMAKE_C_FLAGS='${CFLAGS} ${AdditionalCFlags}'"
    AdditionalFlags+=" -DCMAKE_CXX_FLAGS='${CXXFLAGS} ${AdditionalCFlags}'"
    AdditionalFlags+=" -DCMAKE_SHARED_LINKER_FLAGS='${LDFLAGS} ${AdditionalLDFlags}'"
}

function build() {
    flags

    if [ ! -e "${BuildDirName}" ]; then
        mkdir ${BuildDirName}
    fi

    cd ${BuildDirName}

    eval "${CMakeCommand} -G\"Unix Makefiles\" -DCMAKE_EXECUTABLE_SUFFIX=.html \
            -DCMAKE_BUILD_TYPE=Release \
            -DCMAKE_PREFIX_PATH=\"${SysRootDir}\" \
            -DCMAKE_FIND_ROOT_PATH=\"${SysRootDir}\" \
            -DCMAKE_INSTALL_PREFIX=\"${SysRootDir}\" \
            ${AdditionalFlags} .."

    sed -i -e "s/#define SIZEOF_SIZE_T  1/#define SIZEOF_SIZE_T  4/g" jconfigint.h
    
    make install -j "${MakeConcurrency}"
}
