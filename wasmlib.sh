#/bin/bash

CMakeCommand="cmake -DCMAKE_TOOLCHAIN_FILE=\"${WASI_SDK_ROOT}/share/cmake/wasi-sdk.cmake\" -DWASI_SDK_PREFIX=\"${WASI_SDK_ROOT}\""
MakeCommand="make"

WASI=1

CFLAGS="-O2 -fno-inline -D__wasi__=1 --sysroot=\"${WASI_SDK_ROOT}/share/wasi-sysroot\" -isystem \"${WASI_SDK_ROOT}/share/wasi-sysroot/include\""
CXXFLAGS="-O2 -fno-inline --sysroot=\"${WASI_SDK_ROOT}/share/wasi-sysroot\""
LDFLAGS="-O2 -fno-inline -nostartfiles -nostdlib -Wl,--no-entry -Wl,--export-dynamic"

source ./emlib.sh