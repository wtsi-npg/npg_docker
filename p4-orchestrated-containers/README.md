### p4-orchestrated-containers

##### Description
`p4align.sh` administers a p4 alignment flow using 2 docker containers.
It expects the reference name `$1` and the absolute path to the unaligned
sequence on the host machine `$2` as input arguments.

In case the docker is running inside a boot2docker VM, sequences are properly
copied to and from the VM to ensure functionality. The scripts builds all
needed docker containers locally (future update: downloading from repo),
stitches them together and runs the p4 flow inside the container.

The aligned results are written to `$2`.

###### Usage
```Shell
# p4align.sh <reference> <path to sequence>
./p4align.sh human /Users/Username/npg_docker/sequences/9225_4#1_mt_paired.fq
```

