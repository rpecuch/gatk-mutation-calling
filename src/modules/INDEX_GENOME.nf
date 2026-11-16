process INDEX_GENOME {

    input:
    // Single reference genome file as input
    path ref_genome

    output:
    // Output in the same directory as the input file came from
    path "${ref_genome}.*"

    script:
    // Execute specific script instead: index_ref_genome.sh
    """
    bash ${params.scripts}/index_ref_genome.sh ${ref_genome} .
    """
}