#!/bin/bash

RepositoryName="SDL"
RepositoryAddress="https://github.com/libsdl-org/SDL.git"
RepositoryLicense="zlib License"

function init() {
    cd ${RepositoryDir}

    if [ ! -e "${RepositoryName}" ]; then
        git clone ${RepositoryAddress}
    fi

    cd ${RepositoryName}
}

function clean() {
    rm -rf ${BuildDirName}
}

function flags()
{
    local AdditionalCFlags=""
    AdditionalCFlags+="-DSDL_USE_LIBDBUS=0"
    AdditionalCFlags+=" -DSDL_EVENTS_DISABLED=1"
    AdditionalCFlags+=" -DSDL_VIDEO_DISABLED=1"
    AdditionalCFlags+=" -DSDL_JOYSTICK_DISABLED=1"
    AdditionalCFlags+=" -DSDL_HAPTIC_DISABLED=1"
    AdditionalCFlags+=" -DSDL_SENSOR_DISABLED=1"

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
        -DCMAKE_PREFIX_PATH=\"${SysRootDir}\" \
        -DCMAKE_FIND_ROOT_PATH=\"${SysRootDir}\" \
        -DCMAKE_INSTALL_PREFIX=\"${SysRootDir}\" \
        ${AdditionalFlags} .."
    
    make install -j "${MakeConcurrency}"
}
