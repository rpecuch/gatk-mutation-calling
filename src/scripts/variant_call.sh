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
RAW_VCF="$OUTPUT_DIR/${SAMPLE}.raw.vcf.gz"
SNPS_VCF="$OUTPUT_DIR/${SAMPLE}.snps.vcf.gz"
FILTERED_VCF="$OUTPUT_DIR/${SAMPLE}.snps.filtered.vcf.gz"

# Call variants using HaplotypeCaller
gatk HaplotypeCaller \
    -R "$REFERENCE_FASTA" \
    -I "$INPUT_BAM" \
    -O "$GVCF" \
    -ERC GVCF \
    -L chr19 \
    --sample-name "$SAMPLE"

# Inspect GVCF records
echo "---------Inspecting GVCF records-----------"
bcftools view -H "$GVCF" | head

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
echo "---------Number of SNP records-----------"
bcftools view -v snps -H "$SNPS_VCF" | wc -l

# Filter SNPs based on quality metrics
gatk VariantFiltration \
    -R "$REFERENCE_FASTA" \
    -V "$SNPS_VCF" \
    --filter-expression "QD < 2.0 || FS > 60.0 || MQ < 40.0 || SOR > 3.0" \
    --filter-name "SNP_FILTER" \
    -O "$FILTERED_VCF"

# Count passing SNP records
echo "---------Number of passing SNP records-----------"
bcftools view -f PASS -H "$FILTERED_VCF" | wc -l

echo "Variant calling and filtering completed successfully!"
