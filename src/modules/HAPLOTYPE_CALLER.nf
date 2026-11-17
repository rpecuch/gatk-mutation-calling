process HAPLOTYPE_CALLER {

    input:
    // Single reference genome file
    // one input BAM file for each process
    path reference_files
    path markdup_bam

    output:
    // Output in outputs directory
    path "result.txt"

    script:
    def ref_genome = reference_files.find { it.name.endsWith('.fa') }
    // Execute specific script instead: first part of variant_call.sh
    """
    bash ${projectDir}/${params.scripts}/haplotype_call.sh ${ref_genome} ${markdup_bam} .
    """
}