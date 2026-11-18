process BAM_SORT {

    input:
    // Input SAM file from alignment
    path sam
    path script_dir

    output:
    // Output in outputs directory
    path("*.bam"), emit: bam

    script:
    // Execute specific script instead: sam_to_bam.sh
    """
    bash ${script_dir}/sam_to_bam.sh ${sam} .
    """
}