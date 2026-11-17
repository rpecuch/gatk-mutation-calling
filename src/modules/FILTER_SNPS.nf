process FILTER_SNPS {

    input:
    // Single reference genome file
    // one input SNPs file for each process
    path reference_files
    path snps_vcf

    output:
    // Output in outputs directory
    path("*.snps.filtered.vcf.gz"), emit: snps_filtered_vcf

    script:
    def ref_genome = reference_files.find { it.name.endsWith('.fa') }
    // Execute specific script instead: third part of variant_call.sh
    """
    bash ${projectDir}/${params.scripts}/filter_snps.sh ${ref_genome} ${snps_vcf} ${params.snp_filters} .
    """
}