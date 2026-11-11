#!/usr/bin/env bash

# Check that exactly two inputs are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input.sam> <output_directory>"
    exit 1
fi

# Assign input arguments
INPUT_SAM="$1"
OUTPUT_DIR="$2"

# Extract sample name from input SAM filename
SAMPLE=$(basename "$INPUT_SAM" .sam)

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Define output BAM file
OUTPUT_BAM="$OUTPUT_DIR/${SAMPLE}.sorted.bam"

# Convert SAM to BAM, sort, and index
samtools view -bS "$INPUT_SAM" | \
    samtools sort -o "$OUTPUT_BAM" && \
    samtools index "$OUTPUT_BAM"

# Check whether sorting and indexing succeeded
if [ "$?" -ne 0 ]; then
    echo "Error: BAM sorting or indexing failed."
    exit 1
fi

# Print alignment statistics
echo "---------Alignment statistics in BAM file-----------"
samtools flagstat "$OUTPUT_BAM"

echo "BAM sorting and indexing completed successfully!"
echo "Output BAM: $OUTPUT_BAM"
