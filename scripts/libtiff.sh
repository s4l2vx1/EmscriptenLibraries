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

function flags()
{
    local AdditionalCFlags="-sALLOW_MEMORY_GROWTH=1"
    local AdditionalLDFlags=""

    if [ "${EnableShared}" == "1" ]; then
        AdditionalCFlags+=" -DDLLEXPORT=\"__attribute__((used))\""
        AdditionalLDFlags+="-sSIDE_MODULE=1 -L${SysRootDir}/lib"
        AdditionalFlags="-DBUILD_SHARED_LIBS=1 -DCMAKE_SHARED_LIBRARY_SUFFIX=\".wasm\""      
    else
        AdditionalFlags="-DBUILD_SHARED_LIBS=0"
    fi

    AdditionalFlags+=" -DCMAKE_C_FLAGS='${CFLAGS} ${AdditionalCFlags}'"
    AdditionalFlags+=" -DCMAKE_CXX_FLAGS='${CXXFLAGS} ${AdditionalCFlags}'"
    AdditionalFlags+=" -DCMAKE_SHARED_LINKER_FLAGS='${AdditionalLDFlags}'"
}

function build() {
    flags

    if [ ! -e "${BuildDirName}" ]; then
        mkdir ${BuildDirName}
        cd ${BuildDirName}
    fi

    cd ${BuildDirName}

    eval "${CMakeCommand} -G\"Unix Makefiles\" \
            -DCMAKE_SKIP_INSTALL_ALL_DEPENDENCY=On \
            -DCMAKE_BUILD_TYPE=Release \
            -DCMAKE_PREFIX_PATH=\"${SysRootDir}\" \
            -DCMAKE_FIND_ROOT_PATH=\"${SysRootDir}\" \
            -DCMAKE_INSTALL_PREFIX=\"${SysRootDir}\" \
            ${AdditionalFlags} .."
    
    cmake --build . --target tiff -j "${MakeConcurrency}"
    cmake --install .
}
