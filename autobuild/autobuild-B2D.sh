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
OUTPUT=$1                  # output directory on local machine
DUID="autobuild_$RANDOM"   # Unique ID to avoid multithreading conflicts

# B2D_fileIO, see https://github.com/stepf/boot2docker-fileIO-wrapper
B2D_INPUT_DIR="/mnt/sda1/$DUID"
B2D_OUTPUT_DIR="/mnt/sda1/$DUID/output"
B2D_NAME=""
B2D_PORT=""


# FUNCTIONS ####################################################################

function err {
  echo "$1" 1>&2
  exit 1
}

function docker::build_and_run {
  echo -n "Trying to build sanger_npg/autobuild-$1… "
  if [ -e "$1/Dockerfile" ]; then
    docker build -q -t "sanger_npg/autobuild-$1" "./$1/" && echo "successfully built."
  else
    echo "Could not build $1. Please check if ./$1/Dockerfile is present." 1>&2
    return
  fi
  echo -n "Trying to run container sanger_npg/autobuild-$1 … "
  docker run --name $DUID --rm -v "$OUTPUT:/shared/" "sanger_npg/autobuild-$1"
  echo "done."
}

# Retrieve B2D VM name and port
function B2D_fileIO::get_B2D_name_port {
  B2D_NAME=$(VBoxManage list vms | grep -o -E "[^\"]*docker[^\"]*")
  B2D_PORT=$(VBoxManage showvminfo "$B2D_NAME" \
                  | grep ssh \
                  | grep -o -E "host port = \d+" \
                  | grep -o -E "\d+")
}

# Wrapper for SSHing / SCPing into boot2docker. Handles all the user interaction:
# filling the standard password, sending optional commands $2.
function B2D_fileIO::cmd_expect {
  expect -c "
    set timeout 1
    spawn $1 $2
    expect yes/no { send yes\r ; exp_continue }
    expect password: { send tcuser\r ; exp_continue }
  " || err "FAILED: $1 $2"
}

function B2D_fileIO::copy_files {
  # Only if b2d is running: port and name could be retrieved
  if [ -n "$B2D_PORT" ]; then

    if [ "$1" == "in" ]; then
      # Copy to unique folder in VM to avoid conflicts with multiple threads
      B2D_fileIO::cmd_expect "ssh -p $B2D_PORT docker@localhost" "sudo rm -rf $B2D_INPUT_DIR && sudo mkdir -p $B2D_OUTPUT_DIR && sudo chmod 777 $B2D_OUTPUT_DIR && exit"

    elif [ "$1" == "out" ]; then
      # Copy results and delete afterwards
      B2D_fileIO::cmd_expect "scp -r -P $B2D_PORT docker@localhost:$B2D_OUTPUT_DIR $OUTPUT_DIR"
      B2D_fileIO::cmd_expect "ssh -p $B2D_PORT docker@localhost" "sudo rm -rf $B2D_OUTPUT_DIR $B2D_INPUT_DIR"
    fi

  fi
}


# MAIN #########################################################################

function main {
  if [ $# -le 0 ]; then
    err "USAGE: $PROG <output dir> <optional: specific targets>"
  fi

  B2D_fileIO::get_B2D_name_port
  B2D_fileIO::copy_files "in"

  # Iterate over all / selected folders
  if [ $# -eq 1 ]; then
    iterate_over="./*/"
  elif [ $# -ge 2 ]; then
    iterate_over="${@:2}"
  fi

  docker::build_and_run "baseimage"

  for folder in $iterate_over; do
    dir=$(echo "$folder" | grep -o -E "[^\.\/].*[^\/]")
    docker::build_and_run "$dir"
  done

  B2D_fileIO::copy_files "out"

  exit 0
}

main "$@"
