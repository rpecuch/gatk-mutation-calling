process MARK_DUPLICATES {

    input:
    // Input BAM file for each process
    path bam

    output:
    // Output in outputs directory
    path("*.markdup.bam"), emit: markdup_bam

    script:
    // Execute specific script instead: gatk_prepare.sh
    """
    bash ${projectDir}/${params.scripts}/gatk_prepare.sh ${bam} .
    """
}