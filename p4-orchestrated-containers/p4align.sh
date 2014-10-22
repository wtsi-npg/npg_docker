#!/usr/bin/env bash
#
# Copyright (c) 2014 Genome Research Ltd.
# Author: Stefan Dang <sd15@sanger.ac.uk>
#
# SYNOPSIS: p4align.sh <reference> <path to sequence>
#   This scripts administers a p4 alignment flow with docker containers:
#   It expects the reference name ($1) and the absolute path to the unaligned
#   sequences on the host machine ($2) as input arguments.
#   First sets up a private registry with all images, if not present. Then
#   pulls the needed images, stitches them together and runs the p4 flow inside
#   the container. The aligned results are output in $2.
#
# Maintainer: Stefan Dang <sd15@sanger.ac.uk>

# set -o pipefail
# set -e

# GLOBALS
PROG=$0
REF=$1             # $1 Name of reference container
TARGET=$2          # $2 Absolute path to unaligned sequence on docker host
ALIGNER="p4align"  # Name of alignment container

TARGET_DIR=$(dirname "$TARGET")
TARGET_FILENAME=$(basename "$TARGET")

REGISTRY_PORT=5000 # Port of the Docker Registry

# FUNCTIONS
function err {
  echo "$1" 1>&2
  exit 1
}

# Pull from registry if not present
# $1: image_name
function docker::pull {
  if [ -z "$(docker images | grep "\s$1\s")" ]; then
    docker pull "$1"
  fi
}

# MAIN
function main {
  # Check USAGE
  if [ $# -ne 2 ]; then
    err "USAGE: $PROG <reference> <path to sequence>"
  fi

  # Check for registry
  if [ -z "$(docker ps | grep sanger_registry)" ]; then
    err "Registry is not running. Please set up. See: ./private_registry/setup.sh"
  fi

  # Pull images if not present
  docker::pull "localhost:$REGISTRY_PORT/$REF" || \
    err "Could not pull image. Please set up registry. See: ./private_registry/setup.sh"
  docker::pull "localhost:$REGISTRY_PORT/$ALIGNER" || \
    err "Could not pull image. Please set up registry. See: ./private_registry/setup.sh"

  # Run reference container if not present. Expose folder for mounting.
  [[ -z "$(docker ps -a | grep "\s$REF\s")" ]] && \
    docker run --name "$REF" -v "/reference" "localhost:$REGISTRY_PORT/$REF"

  # Run p4 flow container. Mount both reference folder and host folder.
  docker run --name "$ALIGNER_$RANDOM" --rm --volumes-from="$REF:ro" \
    -v "$TARGET_DIR:/shared/" "localhost:$REGISTRY_PORT/$ALIGNER" "$REF" "$TARGET_FILENAME"

  exit 0
}

main "$@"
