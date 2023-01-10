
rule haplotype_caller:
    input:
        final_cram = "{bucket}/wgs/{breed}/{sample_name}/{ref}/cram/{sample_name}.{ref}.cram",
        final_crai = "{bucket}/wgs/{breed}/{sample_name}/{ref}/cram/{sample_name}.{ref}.cram.crai",
    output:
        final_gvcf     = "{bucket}/wgs/{breed}/{sample_name}/{ref}/gvcf/{sample_name}.{ref}.g.vcf.gz",
        final_gvcf_tbi = "{bucket}/wgs/{breed}/{sample_name}/{ref}/gvcf/{sample_name}.{ref}.g.vcf.gz.tbi",
    params:
        java_opt  = "-Xmx8G -XX:GCTimeLimit=50 -XX:GCHeapFreeLimit=10",
        ref_fasta = config['ref_fasta'],
    benchmark:
        "{bucket}/wgs/{breed}/{sample_name}/{ref}/gvcf/{sample_name}.haplotype_caller.benchmark.txt"
    threads: 4
    resources:
         time   = 10,
         mem_mb = 4000
    shell:
        '''
            gatk --java-options "{params.java_opt}" \
                HaplotypeCaller \
                -R {params.ref_fasta} \
                -I {input.final_cram} \
                -O {output.final_gvcf} \
                -L chr11:49584056-50592157 \
                -contamination 0 -ERC GVCF
        '''

