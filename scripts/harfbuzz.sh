#!/bin/bash

RepositoryName="harfbuzz"
RepositoryAddress="https://github.com/harfbuzz/harfbuzz.git"
RepositoryLicense="MIT License"

function init() {
    cd ${RepositoryDir}

    if [ ! -e "${RepositoryName}" ]; then
        git clone --depth 1 -b 4.3.0 ${RepositoryAddress}

        sed -ie "s/if (UNIX)/if (UNIX AND NOT EMSCRIPTEN)/g" "${RepositoryName}/CMakeLists.txt"
    fi

    cd ${RepositoryName}
}

function clean() {
    rm -rf ${BuildDirName}
}

function flags()
{
    local AdditionalCFlags=""
    local AdditionalLDFlags=""

    if [ "${EnableShared}" == "1" ]; then
        AdditionalCFlags+=" -DHB_EXTERN=\"extern __attribute__((used))\""
        AdditionalLDFlags+="-L${SysRootDir}/lib"
        AdditionalFlags="-DBUILD_SHARED_LIBS=On -DCMAKE_SHARED_LIBRARY_SUFFIX=\".wasm\""      
    else
        AdditionalFlags="-DBUILD_SHARED_LIBS=Off"
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

    eval "${CMakeCommand} -G\"Unix Makefiles\" \
            -DCMAKE_BUILD_TYPE=Release \
            -DHB_HAVE_FREETYPE=On \
            -DCMAKE_PREFIX_PATH=\"${SysRootDir}\" \
            -DCMAKE_FIND_ROOT_PATH=\"${SysRootDir}\" \
            -DCMAKE_INSTALL_PREFIX=\"${SysRootDir}\" \
            ${AdditionalFlags} .."

    make install -j "${MakeConcurrency}"
}
