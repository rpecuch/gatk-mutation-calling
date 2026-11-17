process GENOTYPE_GVCFS {

    input:
    // Single reference genome file
    // one input GVCF file for each process
    path reference_files
    path gvcf

    output:
    // Output in outputs directory
    path("*.g.vcf.gz"), emit: gvcf

    script:
    def ref_genome = reference_files.find { it.name.endsWith('.fa') }
    // Execute specific script instead: first part of variant_call.sh
    """
    bash ${projectDir}/${params.scripts}/genotype_gvcf.sh ${ref_genome} ${gvcf} .
    """
}