process FASTQC {

    input:
    // Two input paired-end files per process, all in same directory
    path read_1
    path read_2

    output:
    // Output in the same directory as the input files came from
    path "result.txt"

    script:
    // Execute specific script instead: fastq_qc.sh
    """
    cat ${read_1} > result.txt
    """
}