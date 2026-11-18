#!/usr/bin/env bash

# Check that exactly four inputs are provided
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <reference.fa> <input.snps.vcf.gz> <filter> <output_directory>"
    exit 1
fi

# Assign input arguments
REFERENCE_FASTA="$1"
SNPS_VCF="$2"
FILTER="$3"
OUTPUT_DIR="$4"

# Extract sample name from input BAM filename
SAMPLE=$(basename "$SNPS_VCF" .snps.vcf.gz)

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Define output file paths
FILTERED_VCF="$OUTPUT_DIR/${SAMPLE}.snps.filtered.vcf.gz"

# Filter SNPs based on quality metrics
gatk VariantFiltration \
    -R "$REFERENCE_FASTA" \
    -V "$SNPS_VCF" \
    --filter-expression "$FILTER" \
    --filter-name "SNP_FILTER" \
    -O "$FILTERED_VCF"

# Count passing SNP records
echo "---------Number of passing SNP records-----------"
bcftools view -f PASS -H "$FILTERED_VCF" | wc -l

echo "Variant calling and filtering completed successfully!"