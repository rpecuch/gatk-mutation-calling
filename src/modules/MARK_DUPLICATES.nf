process MARK_DUPLICATES {

    input:
    // Input BAM file for each process
    path bam
    path script_dir

    output:
    // Output in outputs directory
    path("*.fixedRG.bam"), emit: fixedRG_bam
    tuple path("*.markdup.bam"),
          path("*.markdup.bam.bai"),
          emit: marked_bams

    script:
    // Execute specific script instead: gatk_prepare.sh
    """
    bash ${script_dir}/gatk_prepare.sh ${bam} .
    """
}