#!/usr/bin/env bash

# Check that exactly three inputs are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <benchmark.vcf.gz> <reference.fa> <output_directory>"
    exit 1
fi

# Assign input arguments
BENCHMARK_VCF="$1"
REFERENCE_GENOME="$2"
OUTPUT_DIR="$3"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Create an index for the benchmark VCF
gatk IndexFeatureFile -I "$BENCHMARK_VCF"

# Extract only SNP records from the benchmark set
gatk SelectVariants \
    -R "$REFERENCE_GENOME" \
    -V "$BENCHMARK_VCF" \
    --select-type-to-include SNP \
    -O "$OUTPUT_DIR/GT_NA12878.snps.vcf.gz"

# Apply SNP quality filters
gatk VariantFiltration \
    -R "$REFERENCE_GENOME" \
    -V "$OUTPUT_DIR/GT_NA12878.snps.vcf.gz" \
    --filter-expression "QD < 2.0 || FS > 60.0 || MQ < 40.0 || SOR > 3.0" \
    --filter-name "SNP_FILTER" \
    -O "$OUTPUT_DIR/GT_NA12878.snps.filtered.vcf.gz"

echo "Variant benchmarking preparation completed!"
