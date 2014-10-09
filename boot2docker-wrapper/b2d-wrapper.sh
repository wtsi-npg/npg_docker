#!/usr/bin/env bash
#
# Copyright (c) 2014 Genome Research Ltd.
# Author: Stefan Dang <sd15@sanger.ac.uk>
#
# USAGE: b2d-wrapper.sh <input> <output> <docker image> <optional: args for ENTRYPOINT / CMD>
#
# DESCRIPTION:
#   Docker containers running inside the boot2docker VM mount folders from the VM
#   instead of the local machine, which the user would want to in most cases.
#   b2d-wrapper.sh provides a solution for this by copying the files back and forth.
#   IT IS NOT RECOMMENDED FOR EXTENSIVE USE. Please refer to
#   https://github.com/stepf/boot2docker-fileIO-wrapper

set -o pipefail
set -e


# GLOBALS ######################################################################
PROG=$0
INPUT_DIR=$1
OUTPUT_DIR=$2
IMAGE=$3
DUID="$IMAGE_$RANDOM"   # Unique ID to avoid multithreading conflicts

# B2D_fileIO
B2D_INPUT_DIR="/mnt/sda1/$DUID"
B2D_OUTPUT_DIR="/mnt/sda1/$DUID/output"
B2D_NAME=""
B2D_PORT=""


# FUNCTIONS ####################################################################

function err {
  echo "$1" >&2
  # Clean before exit
  B2D_fileIO::cmd_expect "ssh -p $B2D_PORT docker@localhost" "sudo rm -rf B2D_OUTPUT_DIR B2D_INPUT_DIR"
  exit 1
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

# Main wrapper function, only runs on darwin, win32, msys.
#   ARGUMENTS: $1
#     in  : copy input folder into VM
#     out : copy output folder out of VM, delete input and output folder
function B2D_fileIO::copy_files {
  # Only if b2d is running: port and name could be retrieved
  if [ -n "$B2D_PORT" ]; then

    if [ "$1" == "in" ]; then
      # Copy to unique folder in VM to avoid conflicts with multiple threads
      B2D_fileIO::cmd_expect "ssh -p $B2D_PORT docker@localhost" "sudo rm -rf B2D_INPUT_DIR && sudo mkdir -p B2D_INPUT_DIR B2D_OUTPUT_DIR && sudo chmod 777 B2D_INPUT_DIR B2D_OUTPUT_DIR && exit"
      B2D_fileIO::cmd_expect "scp -r -P $B2D_PORT $INPUT_DIR docker@localhost:2D_INPUT_DIR"

    elif [ "$1" == "out" ]; then
      # Copy results and delete afterwards
      B2D_fileIO::cmd_expect "scp -r -P $B2D_PORT docker@localhost:B2D_OUTPUT_DIR $OUTPUT_DIR"
      B2D_fileIO::cmd_expect "ssh -p $B2D_PORT docker@localhost" "sudo rm -rf B2D_OUTPUT_DIR B2D_INPUT_DIR"
    fi

  fi
}


# MAIN #########################################################################

function main {
  if [ $# -lt 3 ]; then
    err "USAGE: $PROG <input> <output> <docker image> <optional: args for ENTRYPOINT / CMD>"
  fi

  B2D_fileIO::get_B2D_name_port
  B2D_fileIO::copy_files "in"

  # Run your containers here vvvvvvvvvvvvvvvvv
  docker run --name "$DUID" -v "$B2D_INPUT_DIR:/input/" -v "$B2D_OUTPUT_DIR:/output/" \
    "$IMAGE" "${@:4}"
  #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

  B2D_fileIO::copy_files "out"

  exit 0
}

main "$@"
