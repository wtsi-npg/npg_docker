#!/usr/bin/env bash
#
# DESCRIPTION:
#   This scripts tests a smalt alignment pipeline on BaseSpace input.
#
# Copyright (c) 2014 Genome Research Ltd.
# Author: Stefan Dang <sd15@sanger.ac.uk>

# Move input and reference directory to Illumina-conform location
rm -rf /data /genomes
mv /test/data /data
mv /test/genomes /genomes

# Run alignment
/smalt_entrypoint.sh /genomes/Escherichia_coli_K_12_DH10B/NCBI/2008-03-17/Sequence/WholeGenomeFasta/genome 14845845 13 13 500 0 && echo "smalt flow PASSED" || echo " smalt flow FAILED"

# Results can't be compared to expected because they are not deterministic
