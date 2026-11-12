process INDEX_GENOME {

    input:
    path ref_genome

    output:
    path "result.txt"

    script:
    """
    cat ${ref_genome} > result.txt
    """
}

// Pipeline parameters
params {
    ref_genome: Path = 'ref_genome/hg38.fa.gz'
}

// Full workflow definition
workflow {

    main:
    // Collect input parameters
    ref_genome_ch = channel.fromPath(params.ref_genome)
                         .view()
    // Call first process
    INDEX_GENOME(ref_genome_ch)

    publish:
    indexed_genome = INDEX_GENOME.out
}

// Outputs to store
output {
    indexed_genome {
        path 'indexed_genome'
        mode 'copy'
    }
}

process FASTQC {

    input:
    path input_file

    output:
    path "result.txt"

    script:
    """
    cat ${input_file} > result.txt
    """
}

process ALIGN_AND_SORT {

    input:
    path input_file

    output:
    path "result.txt"

    script:
    """
    cat ${input_file} > result.txt
    """
}

process MARK_DUPLICATES {

    input:
    path input_file

    output:
    path "result.txt"

    script:
    """
    cat ${input_file} > result.txt
    """
}

process HAPLOTYPE_CALLER {

    input:
    path input_file

    output:
    path "result.txt"

    script:
    """
    cat ${input_file} > result.txt
    """
}

process GENOTYPE_GVCFS {

    input:
    path input_file

    output:
    path "result.txt"

    script:
    """
    cat ${input_file} > result.txt
    """
}

process FILTER_SNPS {

    input:
    path input_file

    output:
    path "result.txt"

    script:
    """
    cat ${input_file} > result.txt
    """
}