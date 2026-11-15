process ALIGN_AND_SORT {

    input:
    // Single reference genome file
    // two input paired-end files per process, all in same directory
    path ref_genome
    path read_1
    path read_2

    output:
    // Output in outputs directory
    path "result.txt"

    script:
    // Execute specific script instead: ref_seq_align.sh and sam_to_bam.sh
    """
    cat ${input_file} > result.txt
    """
}