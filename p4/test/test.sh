#!/usr/bin/env bash
#
# DESCRIPTION:
#   This scripts tests an example p4 alignment pipeline on an single tile runfolder.
#
# Copyright (c) 2014 Genome Research Ltd.
# Author: Stefan Dang <sd15@sanger.ac.uk>

# globals
p4_templates=./p4_templates
expected_output=./expected_output
test_dir=./tmp
vtf_dir=$test_dir/vtf
out_dir=$test_dir/outdata
cfg_dir=$test_dir/cfgdata
tmp_dir=$test_dir/tmpdata
err_dir=$test_dir/errdata
rpt=12588_1

function run_flow {
  # create subdirectories
  mkdir -p $test_dir $vtf_dir $out_dir $cfg_dir $tmp_dir $err_dir

  # move template files to their own subdirectory
  cp ./$p4_templates/* $vtf_dir/

  # preprocess subgraph vtf templates, convert to json
  grep -v "^#" $vtf_dir/bwa_mem_alignment.vtf | tr -d "\n\t" > $cfg_dir/bwa_mem_alignment.json &&\
  grep -v "^#" $vtf_dir/post_alignment.vtf | tr -d "\n\t" > $cfg_dir/post_alignment.json &&\
  grep -v "^#" $vtf_dir/post_alignment_filter.vtf | tr -d "\n\t" > $cfg_dir/post_alignment_filter.json &&\
  grep -v "^#" $vtf_dir/seqchksum.vtf | tr -d "\n\t" > $cfg_dir/seqchksum.json

  # preprocess main template, convert to json
  vtfp.pl -l tmp/gawp.vtf.log -o tmp/gawp.json \
  -keys bwa_executable -vals bwa \
  -keys illumina2bam_jar -vals /usr/local/jars/Illumina2bam.jar \
  -keys alignment_filter_jar -vals /usr/local/jars/AlignmentFilter.jar \
  -keys outdatadir -vals ./$out_dir \
  -keys cfgdatadir -vals ./$cfg_dir \
  -keys tmpdir -vals ./$tmp_dir \
  -keys i2b_intensity_dir -vals "$(pwd)/runfolder/Data/Intensities" \
  -keys i2b_lane -vals 1 \
  -keys i2b_library_name -vals myi2blib \
  -keys i2b_sample_alias -vals myi2bsample \
  -keys i2b_study_name -vals myi2bstudy \
  -keys i2b_first_tile -vals 1101 \
  -keys i2b_tile_limit -vals 1 \
  -keys rpt -vals $rpt \
  -keys alignment_method -vals bwa_mem \
  -keys reposdir -vals "$(pwd)/references" \
  -keys alignment_refname_target -vals Escherichia_coli/E_coli_B_strain.fasta \
  -keys alignment_refname_phix -vals PhiX/phix_unsnipped_short_no_N.fa \
  -keys picard_dict_name_target -vals Escherichia_coli/E_coli_B_strain.fasta.dict \
  -keys picard_dict_name_phix -vals PhiX/phix_unsnipped_short_no_N.fa.dict \
  -keys refname_fasta_target -vals Escherichia_coli/E_coli_B_strain.fasta \
  -keys refname_fasta_phix -vals PhiX/phix_unsnipped_short_no_N.fa \
  -keys aligner_numthreads -vals 2 \
  -keys java_cmd -vals java \
  <(grep -v "^#" $vtf_dir/generic_alignment_with_phix.vtf | sed -e "s/^ *//" | tr -d "\n\t")

  # run flow
  viv.pl -x -s -v 3 -o tmp/gawp.log tmp/gawp.json
  mv ./*.err $err_dir/

  return 0
}

function compare_results {
  cmp $expected_output/12588_1.bam.md5 $out_dir/$rpt.bam.md5
  cmp $expected_output/12588_1_in.bamseqchecksum $out_dir/"$rpt"_in.bamseqchecksum
  cmp $expected_output/12588_1_out.bamseqchecksum $out_dir/"$rpt"_out.bamseqchecksum
  cmp $expected_output/12588_1.bamstats $out_dir/$rpt.bamstats
  cmp $expected_output/12588_1.flagstat $out_dir/$rpt.flagstat
  cmp $expected_output/12588_1_phix.bamstats $out_dir/"$rpt"_phix.bamstats
  cmp $expected_output/12588_1_phix.flagstat $out_dir/"$rpt"_phix.flagstat

  return 0
}

function main {
  run_flow
  compare_results

  return 0
}

main
