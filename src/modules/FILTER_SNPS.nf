process FILTER_SNPS {

    input:
    // Single reference genome file
    // one input SNPs file for each process
    path input_file

    output:
    // Output in outputs directory
    path "result.txt"

    script:
    // Execute specific script instead: third part of variant_call.sh
    """
    cat ${input_file} > result.txt
    """
}