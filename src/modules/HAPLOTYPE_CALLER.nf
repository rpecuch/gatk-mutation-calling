process HAPLOTYPE_CALLER {

    input:
    // Single reference genome file
    // one input BAM file for each process
    path reference_files
    path dict
    tuple path(markdup_bam),
          path(markdup_bam_bai)

    output:
    // Output in outputs directory
    tuple path("*.g.vcf.gz"),
          path("*.g.vcf.gz.tbi"),
          emit: gvcf

    script:
    def ref_genome = reference_files.find { it.name.endsWith('.fa') }
    // Execute specific script instead: first part of variant_call.sh
    """
    bash ${projectDir}/${params.scripts}/haplotype_call.sh ${ref_genome} ${markdup_bam} .
    """
}