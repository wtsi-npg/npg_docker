#!/usr/bin/env bash
#
# Copyright (c) 2014 Genome Research Ltd.
# Author: Stefan Dang <sd15@sanger.ac.uk>
#
# DESCRIPTION:
#   Automatically build / download all needed binaries for full p4 flow
#   using Dockerfiles as “build recipes”. One container per binary.

set -e

# GLOBALS
PROG=$0
INPUT=$1                 # input directory on local machine
OUTPUT=$2                # output directory on local machine


# FUNCTIONS
function err {
  echo "$1" 1>&2
  exit 1
}

function docker::build_and_run {
  dir=$(basename "$1")
  if [ -e "$1/Dockerfile" ]; then
    docker build -q -t "sanger_npg/autobuild-$dir" "$1" && \
    docker run --rm -v "$OUTPUT:/autobuild/" "sanger_npg/autobuild-$dir" && \
    echo "sanger_npg/autobuild-$dir successfully built."
  else
    echo "$dir skipped: $folder/Dockerfile not present."
    return
  fi
}


# MAIN
function main {
  if [ $# -le 0 ]; then
    err "USAGE: $PROG <input dir> <output dir>"
  fi

  # Iterate over all / selected folders
  if [ $# -eq 2 ]; then
    iterate_over="$INPUT/*/"
  elif [ $# -ge 3 ]; then
    iterate_over="${@:2}"
  fi

  docker::build_and_run "baseimage"

  for folder in $iterate_over; do
    docker::build_and_run "$folder"
  done

  exit 0
}

main "$@"
