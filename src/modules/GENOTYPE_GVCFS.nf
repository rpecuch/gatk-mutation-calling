process GENOTYPE_GVCFS {

    input:
    // Single reference genome file
    // one input GVCF file for each process
    path input_file

    output:
    // Output in outputs directory
    path "result.txt"

    script:
    // Execute specific script instead: second part of variant_call.sh
    """
    cat ${input_file} > result.txt
    """
}