#!/usr/bin/env bash

# Check that exactly two input files are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <R1.fastq.gz> <R2.fastq.gz>"
    exit 1
fi

# Assign input arguments
R1="$1"
R2="$2"

#  Assess the quality of raw paired-end FASTQ files
fastqc "$R1" "$R2"