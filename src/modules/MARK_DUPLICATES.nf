process MARK_DUPLICATES {

    input:
    // Input BAM file for each process
    path input_file

    output:
    // Output in outputs directory
    path "result.txt"

    script:
    // Execute specific script instead: gatk_prepare.sh
    """
    cat ${input_file} > result.txt
    """
}