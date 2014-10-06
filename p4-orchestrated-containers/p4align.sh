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

# GLOBALS ######################################################################

PROG=$0; shift            # $0
REF=$0; shift             # $1 Name of reference container
TARGET=$0; shift          # $2 Absolute path to unaligned sequence on docker host

# Some string manipulation on globals
TARGET_DIR=$(echo "$TARGET" | sed 's#/[^/]*$##')
TARGET_FILENAME=$(echo "$TARGET" | sed 's:.*/::')
ALIGNER=""   # Name of alignment container


# FUNCTIONS ####################################################################

function err {
  echo "$1" 1>&2
  exit 1
}

# TODO (sd15): Speed checking process up for large list of images
function docker::build {
  # Check whether container exists already.
  echo -n "Trying to build sanger_npg/$1… "
  local image_exists=$(docker images | grep "sanger_npg/$1")
  if [ -n "$image_exists" ]; then
    echo "already exists."
  # If not, check Dockerfile and build.
  elif [ -z "$image_exists" ] && [ -e "$1" ]; then
    docker build -q -t "sanger_npg/$1" "./$1/" # will be replaced by docker pull
    echo "successfully built."
  else
    err "Could not build $1. Please check if ./$1/Dockerfile is present."
  fi
}

function docker::run {
  echo -n "Trying to run container sanger_npg/$2 … "
  bash -c "$1" || err "failed!"
  echo "done."
}


# MAIN #########################################################################

# Check USAGE
if [ $# -ne 2 ]; then
  err "USAGE: $PROG <reference> <path to sequence>"
fi

# Build containers
docker::build "$REF"
docker::build "$ALIGNER"

# Run reference container if not present. Expose folder for mounting.
if [ -z "$(docker ps -a | grep "\s$name\s")" ]; then
  docker::run "docker run --name $REF -v /reference sanger_npg/$REF" "$REF"
fi
# Run p4 flow container. Mount both reference folder and host folder.
docker::run "docker run --name $ALIGNER_$RANDOM --rm --volumes-from=$REF:ro \
             -v $TARGET_DIR:/shared/ sanger_npg/$ALIGNER $REF $TARGET_FILENAME" \
             "$ALIGNER"

exit 0
