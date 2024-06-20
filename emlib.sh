#!/bin/bash

function usage() {
    echo "emscripten library building helper"
    echo "usage:"
    echo "  emlib.sh build <package name>"
    echo "  emlib.sh rebuild <package name>"
    echo "  emlib.sh clean <package name>"
    echo "  emlib.sh list"
}

StartDir=`pwd`
ModifiedPackages=()

SysRootDir=`pwd`
RepositoryDir="${SysRootDir}/repositories"
BuildDirName="build_wasm"

MakeConcurrency=$(grep -c ^processor /proc/cpuinfo)
MakeConcurrency=${MakeConcurrency:="1"}
EnableShared=0
EnableThreads=0
EnableSIMD=0

CMakeCommand=${CMakeCommand:="emcmake cmake"}
MakeCommand=${MakeCommand:="emmake make"}

CFLAGS+="-include emscripten/version.h -sUSE_SDL=2 "
CXXFLAGS+="-include emscripten/version.h -sUSE_SDL=2 "

export CFLAGS=${CFLAGS}
export CXXFLAGS=${CXXFLAGS}
export LDFLAGS=${LDFLAGS}
export MakeFlags=""

function analyse_command_lines() {
  shift 1

  while [ "${1}" != "" ]; do
    case "${1}" in
      --sysroot)
        SysRootDir="${2}"
        shift 2;;
      --repository-dir)
        RepositoryDir="${2}"
        shift 2;;
      --build-dir-name)
        BuildDirName="${2}"
        shift 2;;
      --shared)
        EnableShared=1

        CFLAGS+="-sSIDE_MODULE=2 -fPIC -DPIC "
        CXXFLAGS+="-sSIDE_MODULE=2 -fPIC -DPIC "
        LDFLAGS+="-sSIDE_MODULE=2 --oformat=wasm "

        shift 1;;
      --side-module)
        CFLAGS+="-sSIDE_MODULE=2 -fPIC -DPIC "
        CXXFLAGS+="-sSIDE_MODULE=2 -fPIC -DPIC "
        LDFLAGS+="-sSIDE_MODULE=2 "

        shift 1;;
      --simd)
        EnableSIMD=1

        CFLAGS+="-msimd128 -msse4.2 "
        CXXFLAGS+="-msimd128 -msse4.2 "
        LDFLAGS+="-msimd128 -msse4.2 "

        shift 1;;
      --threads)
        EnableThreads=1

        CFLAGS+="-pthread "
        CXXFLAGS+="-pthread "
        LDFLAGS+="-pthread "

        shift 1;;
      -j)
        MakeConcurrency="${2}"
        shift 2;;
      --flags)
        MakeFlags+=" ${2}"
        shift 2;;
      *)
        ModifiedPackages+=( "${1}" )
        shift 1;;
    esac
  done

  export PKG_CONFIG_PATH="${SysRootDir}/lib/pkgconfig:${SysRootDir}/share/pkgconfig"
  export EM_PKG_CONFIG_PATH="${PKG_CONFIG_PATH}"
}

function build_packages() {
  if [ ! -e "${RepositoryDir}" ]; then
    mkdir "${RepositoryDir}"
  fi

  emsdk_env.sh

  while [ "${1}" != "" ]; do
    cd "${StartDir}"
    scriptPath="scripts/${1}.sh"

    if [ ! -e "${scriptPath}" ]; then
      echo "emlib: unknown package '${1}'"
      shift 1
      continue
    fi

    echo "emlib: building package '${1}' ..."

    source ${scriptPath}
    init && build
    shift 1
  done
}

function clean_packages() {

  while [ "${1}" != "" ]; do
    cd "${StartDir}"
    scriptPath="scripts/${1}.sh"

    if [ ! -e "${scriptPath}" ]; then
      echo "emlib: unknown package '${1}'"
      shift 1
      continue
    fi

    echo "emlib: cleaning package '${1}' ..."

    source ${scriptPath}
    init && clean
    shift 1
  done
}

function list() {
  echo "available packages:"

  for scriptPath in `find ./scripts -type f -path "*/*.sh"`; do
    RepositoryLicense=
    source ${scriptPath}
    echo "  ${RepositoryName} <${RepositoryAddress}> (${RepositoryLicense})"
  done
}

function main() {
  analyse_command_lines $*

  case "${1}" in
    build)   
      build_packages "${ModifiedPackages[@]}";;
    rebuild)
      clean_packages "${ModifiedPackages[@]}"
      build_packages "${ModifiedPackages[@]}";;
    clean)
      clean_packages "${ModifiedPackages[@]}";;
    list)
      list;;
    *)
      usage;;
  esac
}

main $*
