process INDEX_GENOME {

    input:
    // Single reference genome file as input
    path ref_genome
    path script_dir

    output:
    // Output in the same directory as the input file came from
    path("*.dict"), emit: dict
    path("*.fa*"), emit: indexed_reference

    script:
    // Execute specific script instead: index_ref_genome.sh
    """
    bash ${script_dir}/index_ref_genome.sh ${ref_genome} .
    """
}