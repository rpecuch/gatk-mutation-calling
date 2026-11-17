process BAM_SORT {

    input:
    // Input SAM file from alignment
    path sam

    output:
    // Output in outputs directory
    path("*.bam"), emit: bam

    script:
    // Execute specific script instead: sam_to_bam.sh
    """
    bash ${projectDir}/${params.scripts}/sam_to_bam.sh ${sam} .
    """
}