#!/usr/bin/env bash

sample_name=$1
bam=$2
consensus_fasta=$3

lines=`wc -l ${consensus_fasta} | cut -f1 -d" "`

if [ $lines -gt 1 ]
then
  # get a count of all non ns

  grep -v '>' ${consensus_fasta} | tr -d "N" | perl -pe 's/\s+//g' | wc -m > ${consensus_fasta}.non_n_count

  #this script prepares for dissemination to GISAID and CLIMB

  #for CLIMB we need need to extract only mapped reads from the bam {sample}.sorted.mapped.bam

  samtools view -F 4 -bh ${bam} > ${sample_name}.sorted.mapped.bam

  #for GISAID we need to rename the fastq entry, we also need to remove leading and trailing Ns {sample}.consensus.gisaid.fasta

  gisaid_header=`echo "hCoV-19/Ghana/${sample_name}/2020"`
  echo ">${gisaid_header}" > ${sample_name}.consensus.gisaid.fasta
  grep -v '>' ${consensus_fasta} >> ${sample_name}.consensus.gisaid.fasta

else
  touch ${sample_name}.consensus.gisaid.fasta
  touch ${sample_name}.sorted.mapped.bam
fi
