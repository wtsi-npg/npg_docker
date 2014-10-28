#!/usr/bin/env bash
#
# Copyright (c) 2014 Genome Research Ltd.
# Author: Stefan Dang <sd15@sanger.ac.uk>

# Error function printing to stdio because of BaseSpace convention
function err {
  echo "$1" && exit 1
}

set -o pipefail
set -e

# Globals
INDEX=$1; shift                   # $1
PROJECT_ID=$1; shift              # $2
INDEX_WORDLEN=$1; shift           # $3
INDEX_STEPSIZE=$1; shift          # $4
INSERT_MAX=$1; shift              # $5
INSERT_MIN=$1; shift              # $6
COMPLETED=0                       # Make sure alignment has run at least once

# Catch empty input, set to standard values
[[ -z "$INDEX_WORDLEN" ]] && INDEX_WORDLEN="13"
[[ -z "$INDEX_STEPSIZE" ]] && INDEX_STEPSIZE="$INDEX_WORDLEN"
[[ -z "$INSERT_MAX" ]] && INSERT_MAX="500"
[[ -z "$INSERT_MIN" ]] && INSERT_MIN="0"


# (For local testing:) Detect if iGenomes present, else: copy local E.coli ref
[[ ! -d /genomes ]] && mv /test/genomes /genomes

# Indexing
smalt index -k "$INDEX_WORDLEN" -s "$INDEX_STEPSIZE" "$INDEX" "$INDEX.fa"

# Prepare output folders, respecting Basespace naming convention
mkdir -p "/data/output/appresults/$PROJECT_ID/smalt"

# Iterate over all files
find /data/
for input_file in /data/input/samples/*/*; do
  # Strip away every file extension beginning with .fastq (e.g. fastq.12.gz)
  filename=$(basename "$input_file")
  file_base=${filename%.fastq.*}
  output_base=/data/output/appresults/$PROJECT_ID/smalt/$file_base

  # Only process R1 (following Illumina naming convention), check for R2 below
  if [[ $file_base =~ _R1 ]]; then
    gzip -dc "$input_file" > input.fastq || err "Could not decompress $filename. Valid sample?"

    # Set post-processing pipeline:
    # bamsort | bamstreamingduplicates | samtools flagstat & stats | recompress
    mkfifo postproc_pipe && \
    bamsort level=0 SO=coordinates fixmates=1 adddupmarksupport=1 \
    < postproc_pipe \
    | bamstreamingmarkduplicates level=0 \
    | tee >(samtools flagstat - > "$output_base.flagstat") \
          >(samtools stats - > "$output_base.stats") \
    | bamrecompress md5=1 md5filename="$output_base.md5" \
                    index=1 indexfilename="$output_base.index" \
    > "$output_base.bam" &

    # Check for R2; Map paired reads, pipe into postproc_pipe
    mate=${input_file/_R1/_R2}
    if [ -e "$mate" ]; then
      gzip -dc "$mate" > mate.fastq
      mate="mate.fastq"
      smalt map -n "$(nproc)" -f bam -i "$INSERT_MAX" -j "$INSERT_MIN" \
      -r 1 "$INDEX" input.fastq "$mate" > postproc_pipe

    # Else: Map single reads, pipe into postproc_pipe
    else
      smalt map -n "$(nproc)" -f bam -r 1 "$INDEX" input.fastq > postproc_pipe
    fi

    wait # for pipe: incomplete results otherwise

    # Check if results are complete
    if ! [[ -e "$output_base.bam" && -e "$output_base.flagstat" && -e "$output_base.stats" \
      && -e "$output_base.md5" && -e "$output_base.index" ]]; then
      err "Results for $input_file are incomplete."
    fi

    # Plot stats
    plot-bamstats "$output_base.stats" \
      -p "/data/output/appresults/$PROJECT_ID/smalt/plot-bamstats/$file_base"

    # Output used binary / library versions (also in bam header)
    echo -e "    bambamc: $bambamc_version\n\
    smalt: $smalt_version\n\
    samtools: $samtools_version\n\
    libmaus: $libmaus_version\n\
    biobambam: $biobambam_version\n"\
    > "$output_base.versions"

    # Tidy up
    rm postproc_pipe input.fastq
    [[ -e "$mate" ]] && rm "$mate"

    COMPLETED=1
  else
    echo "Skipped: $filename ($input_file)"
  fi

done

# Make sure loop has run at least once
[[ $COMPLETED == 0 ]] && err "No alignment has been performed. Please choose \
  compatible fastq.gz input samples"

exit 0
