process INDEX_GENOME {

    input:
    // Single reference genome file as input
    path ref_genome

    output:
    // Output in the same directory as the input file came from
    path("*.dict"), emit: dict
    path("*.fa*"), emit: indexed_reference
    // path("*.dict"), emit: dict
    // path("*.fa"), emit: fa
    // path("*.fa.amb"), emit: fa_amb
    // path("*.fa.ann"), emit: fa_ann
    // path("*.fa.bwt"), emit: fa_bwt
    // path("*.fa.fai"), emit: fa_fai
    // path("*.fa.pac"), emit: fa_pac
    // path("*.fa.sa"), emit: fa_sa

    script:
    // Execute specific script instead: index_ref_genome.sh
    """
    bash ${projectDir}/${params.scripts}/index_ref_genome.sh ${ref_genome} .
    """
}