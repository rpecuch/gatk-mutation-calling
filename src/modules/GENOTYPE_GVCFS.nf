process GENOTYPE_GVCFS {

    input:
    // Single reference genome file
    // one input GVCF file for each process
    path reference_files
    path dict
    tuple path(gvcf),
          path(gvcf_tbi)

    output:
    // Output in outputs directory
    path("*.raw.vcf.gz"), emit: raw_vcf
    tuple path("*.snps.vcf.gz"),
          path("*.snps.vcf.gz.tbi"),
          emit: snps_vcf

    script:
    def ref_genome = reference_files.find { it.name.endsWith('.fa') }
    // Execute specific script instead: first part of variant_call.sh
    """
    bash ${projectDir}/${params.scripts}/genotype_gvcf.sh ${ref_genome} ${gvcf} .
    """
}