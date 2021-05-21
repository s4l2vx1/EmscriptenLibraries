#!/bin/bash

function usage() {
    echo "emscripten library building helper"
    echo "usage:"
    echo "  emlib.sh build <package name>"
    echo "  emlib.sh list"
}

export SysRootDir=`pwd`
export RepositoryDir="${SysRootDir}/repositories"
export PKG_CONFIG_PATH="${SysRootDir}/lib/pkgconfig"
export EM_PKG_CONFIG_PATH="${PKG_CONFIG_PATH}"

function list() {
  echo "available packages:"

  for scriptPath in `find ./scripts -type f -path "*/*.sh"`; do
    RepositoryLicense=
    source ${scriptPath}
    echo "  ${RepositoryName} <${RepositoryAddress}> (${RepositoryLicense})"
  done
}

function build() {
  if [ ! -e "${RepositoryDir}" ]; then
    mkdir "${RepositoryDir}"
  fi

  emsdk_env.sh

  shift 1

  while [ "${1}" != "" ]; do
    scriptPath="scripts/${1}.sh"

    if [ ! -e "${scriptPath}" ]; then
      echo "emlib: unknown package '${1}'"
      shift 1
      continue
    fi

    echo "emlib: building package '${1}' ..."

    source ${scriptPath}
    init && build_wasm
    shift 1
  done
}

function main() {
  case "${1}" in
    build)   
      build $*;;
    list)
      list;;
    *)
      usage;;
  esac
}

main $*
