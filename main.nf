#!/usr/bin/env nextflow

// Include modules
include { INDEX_GENOME } from './src/modules/INDEX_GENOME.nf'
// include { FASTQC } from './src/modules/FASTQC.nf'
// include { ALIGN_AND_SORT } from './src/modules/ALIGN_AND_SORT.nf'
// include { MARK_DUPLICATES } from './src/modules/MARK_DUPLICATES.nf'
// include { HAPLOTYPE_CALLER } from './src/modules/HAPLOTYPE_CALLER.nf'
// include { GENOTYPE_GVCFS } from './src/modules/GENOTYPE_GVCFS.nf'
// include { FILTER_SNPS } from './src/modules/FILTER_SNPS.nf'

// Pipeline parameters
params {
    ref: Path
    scripts: Path
    // TODO: need just single reads input instead
    // read_1: Path = 'reads/sample_R1.fastq.gz'
    // read_2: Path = 'reads/sample_R2.fastq.gz'
    outdir: Path
}

// Full workflow definition
workflow {

    main:
    // Collect input parameters
    ref_genome_ch = channel.fromPath(params.ref)
    // read_1_ch = channel.fromPath(params.read_1)
    // read_2_ch = channel.fromPath(params.read_2)

    // Index the reference genome
    INDEX_GENOME(ref_genome_ch)
    // Perform quality control on the reads
    // FASTQC(read_1_ch, read_2_ch)
    // // Align and sort the reads against the indexed genome
    // ALIGN_AND_SORT(INDEX_GENOME.out, read_1_ch, read_2_ch)

    // // TODO: publish what you want to see at the end
    // publish:
    // fastqc_results = FASTQC.out
}

// Outputs to store
// output {
//     fastqc_results {
//         path 'fastqc_results'
//     }
// }