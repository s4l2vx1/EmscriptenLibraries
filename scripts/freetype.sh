#!/bin/bash

RepositoryName="freetype"
RepositoryAddress="https://github.com/freetype/freetype.git"
RepositoryLicense="FreeType License"

function init() {
    cd ${RepositoryDir}

    if [ ! -e "${RepositoryName}" ]; then
        git clone ${RepositoryAddress} -b VER-2-10-0
    fi

    cd ${RepositoryName}
}

function clean() {
    rm -rf ${BuildDirName}
}

function flags()
{
    local AdditionalCFlags=
    AdditionalFlags="${MakeFlags}"

    if [ "${EnableShared}" == "1" ]; then
        AdditionalCFlags+=" -D\"FT_EXPORT(x)=__attribute__((used)) x\""
        AdditionalFlags+=" -DBUILD_SHARED_LIBS=ON"
    else
        AdditionalFlags+=" -DBUILD_SHARED_LIBS=OFF"
    fi

    AdditionalFlags+=" -DCMAKE_C_FLAGS='${CFLAGS} ${AdditionalCFlags}'"
    AdditionalFlags+=" -DCMAKE_CXX_FLAGS='${CXXFLAGS} ${AdditionalCFlags}'"
    AdditionalFlags+=" -DCMAKE_SHARED_LINKER_FLAGS='${LDFLAGS}'"
}

function build() {
    flags

    if [ ! -e "${BuildDirName}" ]; then
        mkdir ${BuildDirName}
    fi

    cd ${BuildDirName}

    eval "${CMakeCommand} -G\"Unix Makefiles\" \
            -DCMAKE_BUILD_TYPE=Release \
            -DFT_WITH_ZLIB=On \
            -DFT_WITH_PNG=On \
            -DCMAKE_PREFIX_PATH='${SysRootDir}' \
            -DCMAKE_FIND_ROOT_PATH='${SysRootDir}' \
            -DCMAKE_INSTALL_PREFIX='${SysRootDir}' \
            ${AdditionalFlags} .."

    make install -j "${MakeConcurrency}"
}
