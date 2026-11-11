#!/usr/bin/env bash

# Check that exactly four inputs are provided
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <reference.fa> <R1.fastq.gz> <R2.fastq.gz> <output_directory>"
    exit 1
fi

# Assign input arguments
REFERENCE_FASTA="$1"
R1_FASTQ="$2"
R2_FASTQ="$3"
OUTPUT_DIR="$4"

# Extract sample name from R1 filename
SAMPLE=$(basename "$R1_FASTQ" _R1.fastq.gz)

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Define output SAM file
OUTPUT_SAM="$OUTPUT_DIR/${SAMPLE}.sam"

# Align paired-end reads to the reference genome
bwa mem -t 8 \
    "$REFERENCE_FASTA" \
    "$R1_FASTQ" \
    "$R2_FASTQ" \
    > "$OUTPUT_SAM"

# Print alignment statistics
echo "---------Alignment statistics in SAM file-----------"
samtools flagstat "$OUTPUT_SAM"

echo "Alignment completed successfully!"
echo "Output SAM: $OUTPUT_SAM"
