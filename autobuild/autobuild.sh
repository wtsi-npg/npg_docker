#!/bin/bash
#
# Copyright (c) 2014 Genome Research Ltd.
# Author: Stefan Dang <sd15@sanger.ac.uk>
#
# DESCRIPTION:
#   Automatically build / download all needed binaries for full p4 flow (HiSeqX /
#   RNA / QC) using Dockerfiles as “build recipes”. One container per binary.


# GLOBALS ######################################################################

PROG=$0                    # ARGV[0]
INPUT=$1                  # output directory on local machine
OUTPUT=$2

# FUNCTIONS ####################################################################

function err {
  echo "$1" 1>&2
  exit 1
}

function docker::build_and_run {
  dir=$(basename "$1")
  echo -n "Trying to build sanger_npg/autobuild-$dir… "
  if [ -e "$1/Dockerfile" ]; then
    docker build -q -t "sanger_npg/autobuild-$dir" "$1" && echo "successfully built."
  else
    echo "Could not build $dir. Please check if $folder/Dockerfile is present." 1>&2
    return
  fi
  echo -n "Trying to run container sanger_npg/autobuild-$dir … "
  docker run --rm -v "$OUTPUT:/shared/" "sanger_npg/autobuild-$dir"
  echo "done."
}


# MAIN #########################################################################

function main {
  if [ $# -le 0 ]; then
    err "USAGE: $PROG <output dir> <optional: specific targets>"
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
