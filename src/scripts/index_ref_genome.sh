#!/usr/bin/env bash

# Check that exactly two inputs are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <reference.fa.gz> <output_directory>"
    exit 1
fi

# Assign input arguments
INPUT_FASTA="$1"
OUTPUT_DIR="$2"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Extract reference name from input filename
REFERENCE=$(basename "$INPUT_FASTA" .fa.gz)

# Define output reference FASTA path
REFERENCE_FASTA="$OUTPUT_DIR/${REFERENCE}.fa"

# Decompress the reference FASTA
gunzip -c "$INPUT_FASTA" > "$REFERENCE_FASTA"

# Build the BWA index
# Note: takes about 30 minutes to run
bwa index "$REFERENCE_FASTA"

# Create FASTA index
samtools faidx "$REFERENCE_FASTA"

# Generate GATK sequence dictionary
gatk CreateSequenceDictionary -R "$REFERENCE_FASTA"

echo "Reference genome indexing completed successfully!"
