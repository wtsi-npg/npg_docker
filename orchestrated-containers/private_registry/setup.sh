#!/usr/bin/env bash
#
# Copyright (c) 2014 Genome Research Ltd.
# Author: Stefan Dang <sd15@sanger.ac.uk>
#
# SYNOPSIS: setup_priv-repo.sh
#   This scripts sets up a private docker repository. Then builds all needed
#   docker containers for a p4 bwa_mem alignment pipeline, namely reference
#   container(s) and the p4 container itself.
#
# Maintainer: Stefan Dang <sd15@sanger.ac.uk>

# Globals
REGISTRY_PORT=5000

# Builds an image if Dockerfile present
# $1: Directory containing Dockerfile
function docker::build {
  dir=$(basename "$1")
  if [ -e "$1/Dockerfile" ]; then
    docker build -q -t "localhost:$REGISTRY_PORT/$dir" "$1" && \
    docker push "localhost:$REGISTRY_PORT/$dir" && \
    echo "sanger_npg/$dir successfully pushed."
  else
    echo "$dir skipped: $folder/Dockerfile not present."
  fi
}

# Set up registry and build all images
function docker::setup_registry {
    echo "Setting up private repository on port $REGISTRY_PORT:"
    docker run --name sanger_registry -d -p $REGISTRY_PORT:5000 registry
}

function main {
  # Setup registry if not already running
  if [ -z "$(docker ps | grep sanger_registry)" ]; then
    docker::setup_registry
  fi

  # Build images and push to registry
  for folder in ./private_registry/*; do
    docker::build "$folder"
  done
}

main "$@"
