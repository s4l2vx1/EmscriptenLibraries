#!/bin/bash

RepositoryName="opus"
RepositoryAddress="https://github.com/xiph/opus.git"
RepositoryLicense="BSD 3-Clause License"

function init() {
    cd ${RepositoryDir}

    if [ ! -e "${RepositoryName}" ]; then
        git clone --depth 1 -b v1.3.1 ${RepositoryAddress}

        cd ${RepositoryName}

        sed -i -e "s/set(VERSION \${OPUS_LIBRARY_VERSION})/set(VERSION \${PACKAGE_VERSION})/g" CMakeLists.txt
        
        ./update_version
    else
        cd ${RepositoryName}
    fi
}

function clean() {
    rm -rf ${BuildDirName}
}

function flags()
{
    local AdditionalCFlags="-sALLOW_MEMORY_GROWTH=1"
    local AdditionalLDFlags=""

    if [ "${EnableShared}" == "1" ]; then
        AdditionalCFlags+=" -DOPUS_EXPORT=\"__attribute__((used))\""
        AdditionalFlags="-DOPUS_BUILD_SHARED_LIBRARY=ON -DCMAKE_SHARED_LIBRARY_SUFFIX=\".wasm\""      
    else
        AdditionalFlags="-DOPUS_BUILD_SHARED_LIBRARY=OFF"
    fi

    if [ "${EnableSIMD}" == "1" ]; then
        AdditionalFlags+=" -DOPUS_DISABLE_INTRINSICS=ON"      
    else
        AdditionalFlags+=" -DOPUS_DISABLE_INTRINSICS=OFF"
    fi

    AdditionalFlags+=" -DOPUS_STACK_PROTECTOR=OFF -DCMAKE_C_FLAGS='${CFLAGS} ${AdditionalCFlags}'"
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
            -DOPUS_INSTALL_PKG_CONFIG_MODULE=On \
            -DCMAKE_PREFIX_PATH=\"${SysRootDir}\" \
            -DCMAKE_FIND_ROOT_PATH=\"${SysRootDir}\" \
            -DCMAKE_INSTALL_PREFIX=\"${SysRootDir}\" \
            ${AdditionalFlags} .."
    
    make install -j "${MakeConcurrency}"
}
