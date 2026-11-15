process INDEX_GENOME {

    input:
    // Single reference genome file as input
    path ref_genome

    output:
    // Output in the same directory as the input file came from
    path "result.txt"

    script:
    // Execute specific script instead: index_ref_genome.sh
    """
    cat ${ref_genome} > result.txt
    """
}