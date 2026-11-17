#!/usr/bin/env nextflow

// Include modules
include { INDEX_GENOME } from './src/modules/INDEX_GENOME.nf'
include { FASTQC } from './src/modules/FASTQC.nf'
include { ALIGN_REF } from './src/modules/ALIGN_REF.nf'
include { BAM_SORT } from './src/modules/BAM_SORT.nf'
include { MARK_DUPLICATES } from './src/modules/MARK_DUPLICATES.nf'
// include { HAPLOTYPE_CALLER } from './src/modules/HAPLOTYPE_CALLER.nf'
// include { GENOTYPE_GVCFS } from './src/modules/GENOTYPE_GVCFS.nf'
// include { FILTER_SNPS } from './src/modules/FILTER_SNPS.nf'

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
    // Collect input parameters
    ref_genome_ch = channel.fromPath(params.ref)
    reads_ch = Channel.fromFilePairs("${params.reads}/*_{R1,R2}.fastq.gz")

    // Index the reference genome
    INDEX_GENOME(ref_genome_ch)
    // Perform quality control on the reads
    FASTQC(reads_ch)
    // Align and sort the reads against the indexed genome
    reference_files = INDEX_GENOME.out.indexed_reference
    .collect()

    // reference_reads = reference_files
    //     .combine(reads_ch)

    ALIGN_REF(reference_files, reads_ch)
    BAM_SORT(ALIGN_REF.out.sam)

    // Mark duplicates in the sorted BAM file
    MARK_DUPLICATES(BAM_SORT.out.bam)

    // Publish outputs
    publish:
    // indexed_genome = INDEX_GENOME.out
    html_reports = FASTQC.out.html
    zip_reports = FASTQC.out.zip
    // sam_aligned = ALIGN_REF.out.sam
    sam_log = ALIGN_REF.out.log
    bam_sorted = BAM_SORT.out.bam
}

// Outputs to store
output {
    // indexed_genome {
    //     path "ref_genome/"
    // }
    html_reports {
        path "fastqc/html"
    }
    zip_reports {
        path "fastqc/zip"
    }
    // sam_aligned {
    //     path ""
    // }
    sam_log {
        path ""
    }
    bam_sorted {
        path ""
    }
}