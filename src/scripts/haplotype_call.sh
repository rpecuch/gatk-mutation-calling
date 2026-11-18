#!/usr/bin/env bash

# Check that exactly three inputs are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <reference.fa> <input.markdup.bam> <output_directory>"
    exit 1
fi

# Assign input arguments
REFERENCE_FASTA="$1"
INPUT_BAM="$2"
OUTPUT_DIR="$3"

# Extract sample name from input BAM filename
SAMPLE=$(basename "$INPUT_BAM" .markdup.bam)

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Define output file paths
GVCF="$OUTPUT_DIR/${SAMPLE}.g.vcf.gz"

# Call variants using HaplotypeCaller
gatk HaplotypeCaller \
    -R "$REFERENCE_FASTA" \
    -I "$INPUT_BAM" \
    -O "$GVCF" \
    -ERC GVCF \
    --sample-name "$SAMPLE"

# Inspect GVCF records
echo "---------Inspecting GVCF records-----------"
bcftools view -H "$GVCF" | head