process ALIGN_REF {

    input:
    // Single reference genome file
    // two input paired-end files per process, all in same directory
    path reference_files
    tuple val(sample_id), path(reads)

    output:
    // Output in outputs directory
    path("*.sam"), emit: sam
    path("*.log"), emit: log

    script:
    def ref_genome = reference_files.find { it.name.endsWith('.fa') }
    // Execute specific script instead: ref_seq_align.sh
    """
    bash ${projectDir}/${params.scripts}/ref_seq_align.sh ${ref_genome} ${reads[0]} ${reads[1]} .
    """
}