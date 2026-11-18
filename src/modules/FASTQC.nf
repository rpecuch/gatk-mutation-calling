process FASTQC {

    input:
    // Two input paired-end files per process, all in same directory
    tuple val(sample_id), path(reads)
    path script

    output:
    path("*.zip"), emit: zip
    path("*.html"), emit: html

    script:
    // Execute specific script instead: fastq_qc.sh
    """
    bash ${script} ${reads[0]} ${reads[1]}
    """
}