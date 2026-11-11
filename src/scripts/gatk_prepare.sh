#!/bin/bash

# Check that exactly two inputs are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input.sorted.bam> <output_directory>"
    exit 1
fi

# Assign input arguments
INPUT_BAM="$1"
OUTPUT_DIR="$2"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Extract sample name from input BAM filename
SAMPLE=$(basename "$INPUT_BAM" .sorted.bam)

# Define output file paths using the extracted sample name
FIXED_RG_BAM="$OUTPUT_DIR/${SAMPLE}.fixedRG.bam"
MARKDUP_BAM="$OUTPUT_DIR/${SAMPLE}.markdup.bam"
METRICS_FILE="$OUTPUT_DIR/${SAMPLE}.markdup.metrics.txt"

# Add required read-group metadata
gatk AddOrReplaceReadGroups \
    -I "$INPUT_BAM" \
    -O "$FIXED_RG_BAM" \
    -RGID 1 \
    -RGLB lib1 \
    -RGPL ILLUMINA \
    -RGPU unit1 \
    -RGSM "$SAMPLE"

# Build an index for the BAM file
samtools index "$FIXED_RG_BAM"

# Inspect header
echo "---------Read group information in BAM file-----------"
samtools view -H "$FIXED_RG_BAM" | grep '^@RG'

# Inspect individual read tags
echo "---------Individual read information-----------"
samtools view "$FIXED_RG_BAM" | head

# Mark duplicate reads and generate metrics
gatk MarkDuplicates \
    -I "$FIXED_RG_BAM" \
    -O "$MARKDUP_BAM" \
    -M "$METRICS_FILE"

# Build an index for the marked-duplicates BAM file
samtools index "$MARKDUP_BAM"

# Count duplicate reads
echo "---------Number of duplicate reads in BAM file-----------"
samtools view -c -f 1024 "$MARKDUP_BAM"

echo "BAM processing completed successfully!"
echo "Output files:"
echo "$FIXED_RG_BAM"
echo "$MARKDUP_BAM"
echo "$METRICS_FILE"
