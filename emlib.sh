#!/bin/bash

function usage() {
    echo "emscripten library building helper"
    echo "usage:"
    echo "  emlib.sh build <package name>"
}

export SysRootDir=`pwd`
export RepositoryDir="${SysRootDir}/repositories"

function build() {
  emsdk_env.sh

  shift 1

  while [ "${1}" != "" ]; do
    scriptPath="scripts/${1}.sh"

    if [ ! -e "${scriptPath}" ]; then
      echo "emlib: unknown package '${1}'"
      shift 1
      continue
    fi

    source ${scriptPath}
    init && build_wasm
    shift 1
  done
}

function main() {
  case "${1}" in
    build)   
      build $*;;
    *)
      usage;;
  esac
}

main $*
