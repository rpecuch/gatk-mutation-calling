#!/usr/bin/env bash

# Check that exactly three inputs are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <reference.fa> <input.g.vcf.gz> <output_directory>"
    exit 1
fi

# Assign input arguments
REFERENCE_FASTA="$1"
GVCF="$2"
OUTPUT_DIR="$3"

# Extract sample name from input BAM filename
SAMPLE=$(basename "$GVCF" .g.vcf.gz)

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Define output file paths
RAW_VCF="$OUTPUT_DIR/${SAMPLE}.raw.vcf.gz"
SNPS_VCF="$OUTPUT_DIR/${SAMPLE}.snps.vcf.gz"

# Convert GVCF to VCF format through joint genotyping
gatk GenotypeGVCFs \
    -R "$REFERENCE_FASTA" \
    -V "$GVCF" \
    -O "$RAW_VCF"

# Select SNPs
gatk SelectVariants \
    -R "$REFERENCE_FASTA" \
    -V "$RAW_VCF" \
    --select-type-to-include SNP \
    -O "$SNPS_VCF"

# Count SNP records
# echo "---------Number of SNP records-----------"
# bcftools view -v snps -H "$SNPS_VCF" | wc -l