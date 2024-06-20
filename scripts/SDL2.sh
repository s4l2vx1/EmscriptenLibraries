#!/bin/bash

RepositoryName="SDL"
RepositoryAddress="https://github.com/libsdl-org/SDL.git"
RepositoryLicense="zlib License"

function init() {
    cd ${RepositoryDir}

    if [ ! -e "${RepositoryName}" ]; then
        git clone -b release-2.26.x  ${RepositoryAddress}
    fi

    cd ${RepositoryName}
}

function clean() {
    rm -rf ${BuildDirName}
}

function flags()
{
    local AdditionalCFlags=""

    if [ "${EnableSIMD}" == "1" ]; then
        AdditionalFlags+=" -DSDL_SSE=On"
        AdditionalFlags+=" -DSDL_SSE2=On"
        AdditionalFlags+=" -DSDL_SSE3=On"
        AdditionalFlags+=" -DSDL_SSEMATH=On"
    fi

    AdditionalFlags+=" -DCMAKE_C_FLAGS='${CFLAGS} ${AdditionalCFlags}'"
    AdditionalFlags+=" -DCMAKE_CXX_FLAGS='${CXXFLAGS} ${AdditionalCFlags}'"
    AdditionalFlags+=" -DCMAKE_SHARED_LINKER_FLAGS='${LDFLAGS}'"
    AdditionalFlags+=" -DSDL_AUDIO=ON"
    AdditionalFlags+=" -DSDL_EVENTS=ON"
    AdditionalFlags+=" -DSDL_DISKAUDIO=OFF"
    AdditionalFlags+=" -DSDL_ATOMIC=OFF"
    AdditionalFlags+=" -DSDL_VIDEO=OFF"
    AdditionalFlags+=" -DSDL_RENDER=OFF"
    AdditionalFlags+=" -DSDL_JOYSTICK=OFF"
    AdditionalFlags+=" -DSDL_HAPTIC=OFF"
    AdditionalFlags+=" -DSDL_HIDAPI=OFF"
    AdditionalFlags+=" -DSDL_POWER=OFF"
    AdditionalFlags+=" -DSDL_THREADS=OFF"
    AdditionalFlags+=" -DSDL_TIMERS=OFF"
    AdditionalFlags+=" -DSDL_FILE=OFF"
    AdditionalFlags+=" -DSDL_LOADSO=OFF"
    AdditionalFlags+=" -DSDL_FILESYSTEM=OFF"
    AdditionalFlags+=" -DSDL_SENSOR=OFF"
    AdditionalFlags+=" -DSDL_LOCALE=OFF"
    AdditionalFlags+=" -DSDL_MISC=OFF"
}

function build() {
    flags

    if [ ! -e "${BuildDirName}" ]; then
        mkdir ${BuildDirName}
    fi

    cd ${BuildDirName}

    eval "${CMakeCommand} -G\"Unix Makefiles\" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_PREFIX_PATH=\"${SysRootDir}\" \
        -DCMAKE_FIND_ROOT_PATH=\"${SysRootDir}\" \
        -DCMAKE_INSTALL_PREFIX=\"${SysRootDir}\" \
        ${AdditionalFlags} .."
    
    make install -j "${MakeConcurrency}"
}
