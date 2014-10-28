### orchestrated-containers

#### Description
`p4align.sh` administers a p4 alignment flow using 2 docker containers. It expects the reference name `$1` and the absolute path to the unaligned sequence on the host machine `$2` as input arguments.

The scripts sets up a private repository, builds all images from the Dockerfiles sitting in `./private_registry/*/` and pushes them to the private repository. (This is useless at the moment as the registry is running on the host system and can be seen as a mere proof of concept.)

The specified alignment container and reference container are pulled, stitched together and the computation is then performed. The aligned results are written to `$2`.

##### Usage
```Shell
# p4align.sh <reference> <path to sequence>
./p4align.sh human ./testinput/9225_4#1_mt_paired.fq
```

