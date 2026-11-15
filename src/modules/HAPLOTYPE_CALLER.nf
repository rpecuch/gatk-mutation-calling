process HAPLOTYPE_CALLER {

    input:
    // Single reference genome file
    // one input BAM file for each process
    path input_file

    output:
    // Output in outputs directory
    path "result.txt"

    script:
    // Execute specific script instead: first part of variant_call.sh
    """
    cat ${input_file} > result.txt
    """
}