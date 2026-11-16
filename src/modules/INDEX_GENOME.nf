process INDEX_GENOME {

    input:
    // Single reference genome file as input
    path ref_genome

    output:
    // Output in the same directory as the input file came from
    path "${ref_genome.baseName}.*"

    script:
    // Execute specific script instead: index_ref_genome.sh
    """
    bash ${projectDir}/${params.scripts}/index_ref_genome.sh ${ref_genome} .
    """
}