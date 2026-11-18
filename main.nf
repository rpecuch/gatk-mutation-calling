#!/usr/bin/env nextflow

// Include modules
include { INDEX_GENOME } from './src/modules/INDEX_GENOME.nf'
include { FASTQC } from './src/modules/FASTQC.nf'
include { ALIGN_REF } from './src/modules/ALIGN_REF.nf'
include { BAM_SORT } from './src/modules/BAM_SORT.nf'
include { MARK_DUPLICATES } from './src/modules/MARK_DUPLICATES.nf'
include { HAPLOTYPE_CALLER } from './src/modules/HAPLOTYPE_CALLER.nf'
include { GENOTYPE_GVCFS } from './src/modules/GENOTYPE_GVCFS.nf'
include { FILTER_SNPS } from './src/modules/FILTER_SNPS.nf'

// Pipeline parameters
params {
    ref: Path
    scripts: Path
    outdir: Path
    reads: Path
}

// Full workflow definition
workflow {

    main:
    scriptsDir = "${projectDir}/${params.scripts}"

    // Collect input parameters
    ref_genome_ch = channel.fromPath(params.ref)
    reads_ch = Channel.fromFilePairs("${params.reads}/*_{R1,R2}.fastq.gz")

    // Index the reference genome
    // TODO: need to make this same replacement for other process calls that use scripts
    INDEX_GENOME(ref_genome_ch, file("${scriptsDir}"))
    // Perform quality control on the reads
    FASTQC(reads_ch, file("${scriptsDir}/fastq_qc.sh"))
    // Align and sort the reads against the indexed genome
    reference_files = INDEX_GENOME.out.indexed_reference
    .collect()
    genome_dict = INDEX_GENOME.out.dict
    .first()

    ALIGN_REF(reference_files, reads_ch)
    BAM_SORT(ALIGN_REF.out.sam)

    // Mark duplicates in the sorted BAM file
    MARK_DUPLICATES(BAM_SORT.out.bam)

    // Variant calling
    // ~ 50 minutes to get to this point
    HAPLOTYPE_CALLER(reference_files, genome_dict, MARK_DUPLICATES.out.marked_bams)
    GENOTYPE_GVCFS(reference_files, genome_dict, HAPLOTYPE_CALLER.out.gvcf)

    // Filter variants
    FILTER_SNPS(reference_files, genome_dict, GENOTYPE_GVCFS.out.snps_vcf)

    // Publish outputs
    publish:
    html_reports = FASTQC.out.html
    zip_reports = FASTQC.out.zip
    filtered_snps_vcf = FILTER_SNPS.out.snps_filtered_vcf
}

// Outputs to store
output {
    html_reports {
        path "fastqc/html"
    }
    zip_reports {
        path "fastqc/zip"
    }
    filtered_snps_vcf{
        path "filtered_snps"
    }
}