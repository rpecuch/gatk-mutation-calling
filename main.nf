#!/usr/bin/env nextflow

// Include modules
include { INDEX_GENOME } from './src/modules/INDEX_GENOME.nf'
include { FASTQC } from './src/modules/FASTQC.nf'
// include { ALIGN_AND_SORT } from './src/modules/ALIGN_AND_SORT.nf'
// include { MARK_DUPLICATES } from './src/modules/MARK_DUPLICATES.nf'
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
    // // Align and sort the reads against the indexed genome
    // ALIGN_AND_SORT(INDEX_GENOME.out, read_1_ch, read_2_ch)

    // Publish outputs
    publish:
    indexed_genome = INDEX_GENOME.out
    html_reports = FASTQC.out.html
    zip_reports = FASTQC.out.zip
}

// Outputs to store
output {
    indexed_genome {
        path "${params.ref.parent}"
    }
    html_reports {
        path "${params.outdir}/fastqc/html"
    }
    zip_reports {
        path "${params.outdir}/fastqc/zip"
    }
}