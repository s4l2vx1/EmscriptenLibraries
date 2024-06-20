#!/bin/bash

export RepositoryName="jumanpp"
RepositoryAddress="https://github.com/ku-nlp/jumanpp.git"
RepositoryLicense="Apache-2.0 License"

function init() {
    cd ${RepositoryDir}

    if [ ! -e "${RepositoryName}" ]; then
        git clone ${RepositoryAddress}

        sed -ie "s/#if defined(__linux__)/#if defined(__linux__) || defined(EMSCRIPTEN)/g" ${RepositoryName}/libs/pathie-cpp/src/path.cpp
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
            -DJPP_ENABLE_TESTS=Off \
            -DCMAKE_PREFIX_PATH="${SysRootDir}" \
            -DCMAKE_FIND_ROOT_PATH="${SysRootDir}" \
            -DCMAKE_INSTALL_PREFIX="${SysRootDir}" \
            -DCMAKE_CXX_FLAGS="${CXXFLAGS} -Wno-narrowing" \
            -DJPP_CODEGEN_LDFLAGS="-lnodefs.js --pre-js ${StartDir}/scripts/jumanpp.codegen.pre.js" \
            -DJPP_EXECUTABLE_LDFLAGS="-sFILESYSTEM=0 -sMINIFY_HTML=0" \
            ..
    else
        cd ${BuildDirName}
    fi
    
    make install -j "${MakeConcurrency}"
}
