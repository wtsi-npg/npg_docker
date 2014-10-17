#!/bin/bash

# Debugging, this will be removed
if [ "$1" == "bash" ]; then
  bash
else
  # The real entrypoint
  # /shared and / reference will be mounted by the container
  mkdir -p /shared/output
  viv.pl -s -x -v3 -o "/shared/output/viv_$2.log" <(vtfp.pl -l "/shared/output/vtpf_$2.log" \
    -keys index_input -vals "/reference/$1.fa" \
    -keys fastq_input -vals "/shared/$2" \
    -keys sam_output -vals "/shared/output/aligned_$2.sam" \
    -keys paired_flag -vals '-p' \
    bwa_align.json)
fi


