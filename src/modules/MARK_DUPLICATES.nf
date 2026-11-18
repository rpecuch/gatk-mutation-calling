process MARK_DUPLICATES {

    input:
    // Input BAM file for each process
    path bam

    output:
    // Output in outputs directory
    path("*.fixedRG.bam"), emit: fixedRG_bam
    tuple path("*.markdup.bam"),
          path("*.markdup.bam.bai"),
          emit: marked_bams

    script:
    // Execute specific script instead: gatk_prepare.sh
    """
    bash ${projectDir}/${params.scripts}/gatk_prepare.sh ${bam} .
    """
}