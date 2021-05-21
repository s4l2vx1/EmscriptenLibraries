#!/bin/bash

RepositoryName="FFmpeg"
RepositoryAddress="https://github.com/FFmpeg/FFmpeg.git"
RepositoryLicense="LGPL v2.1, v3.0; GPL v2.1, v3.0"

function init() {
    cd ${RepositoryDir}

    if [ ! -e "${RepositoryName}" ]; then
        git clone --depth 1 ${RepositoryAddress}
    fi

    cd ${RepositoryName}
}

function build_wasm() {
    emconfigure ./configure --cc=emcc --ar=emar --ranlib=emranlib --prefix=${SysRootDir} \
        --enable-cross-compile --target-os=none --arch=x86_32 --cpu=generic \
        --disable-stripping --disable-programs --disable-asm --disable-doc --disable-pthreads --disable-w32threads --disable-debug \
        --enable-decoder=hevc --enable-parser=hevc --enable-demuxer=hevc --enable-decoder=h264 --enable-parser=h264 --enable-demuxer=h264
    make
    make install
}

function build_wasm_pic() {
    # TODO: Add -fPIC Flag
    emconfigure ./configure --cc=emcc --ar=emar --ranlib=emranlib --prefix=${SysRootDir} \
        --enable-cross-compile --target-os=none --arch=x86_32 --cpu=generic \
        --disable-stripping --disable-programs --disable-asm --disable-doc --disable-pthreads --disable-w32threads --disable-debug \
        --enable-decoder=hevc --enable-parser=hevc --enable-demuxer=hevc --enable-decoder=h264 --enable-parser=h264 --enable-demuxer=h264
    make
    make install
}

function build_asmjs() {
    emconfigure ./configure --cc=emcc --ar=emar --ranlib=emranlib --prefix=${SysRootDir} \
        --enable-cross-compile --target-os=none --arch=x86_32 --cpu=generic \
        --disable-stripping --disable-programs --disable-asm --disable-doc --disable-pthreads --disable-w32threads --disable-debug \
        --enable-decoder=hevc --enable-parser=hevc --enable-demuxer=hevc --enable-decoder=h264 --enable-parser=h264 --enable-demuxer=h264
    make
    make install
}
