#!/usr/bin/env bash
#
# Copyright (c) 2014 Genome Research Ltd.
# Author: Stefan Dang <sd15@sanger.ac.uk>
#
# SYNOPSIS: p4align.sh <reference> <path to sequence>
#   This scripts administers a p4 alignment flow with docker containers:
#   It expects the reference name ($1) and the absolute path to the unaligned
#   sequences on the host machine ($2) as input arguments.
#   The scripts builds all needed docker containers locally (future update:
#   downloading from repo), stitches them together and runs the p4 flow inside
#   the container. The aligned results are output in $2.
#
# Maintainer: Stefan Dang <sd15@sanger.ac.uk>

set -o pipefail
set -e

# GLOBALS
PROG=$1
REF=$2             # $1 Name of reference container
TARGET=$3          # $2 Absolute path to unaligned sequence on docker host
ALIGNER="p4align"  # Name of alignment container

TARGET_DIR=$(dirname "$TARGET")
TARGET_FILENAME=$(basename "$TARGET")


# FUNCTIONS
function err {
  echo "$1" 1>&2
  exit 1
}

# TODO (sd15): Speed checking process up for large list of images
function docker::build {
  # Check whether container exists already.
  local image_exists=$(docker images | grep "sanger_npg/$1")
  if [ -n "$image_exists" ]; then
    echo "sanger_npg/$1 exists."
  # If not, check Dockerfile and build.
  elif [ -z "$image_exists" ] && [ -e "$1" ]; then
    docker build -q -t "sanger_npg/$1" "./$1/" # will be replaced by docker pull
    echo "sanger_npg/$1 successfully built."
  else
    err "Could not build $1. Please check if ./$1/Dockerfile is present."
  fi
}


# MAIN
function main {
  # Check USAGE
  if [ $# -ne 2 ]; then
    err "USAGE: $PROG <reference> <path to sequence>"
  fi

  # Build containers
  docker::build "$REF"
  docker::build "$ALIGNER"

  # Run reference container if not present. Expose folder for mounting.
  [[ -z "$(docker ps -a | grep "\s$name\s")" ]] && \
    docker run --name "$REF" -v "/reference" "sanger_npg/$REF"

  # Run p4 flow container. Mount both reference folder and host folder.
  docker run --name "$ALIGNER_$RANDOM" --rm --volumes-from="$REF:ro" \
    -v "$TARGET_DIR:/shared/" "sanger_npg/$ALIGNER" "$REF" "$TARGET_FILENAME"

  exit 0
}

main "$@"
