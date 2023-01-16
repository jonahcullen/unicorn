
rule import_gvcfs:
    input:
        gvcf_list = "joint.list",
    output:
        directory("{bucket}/wgs/pipeline/{ref}/{date}/import_gvcfs/unicorn_chr11_49584056-50592157")
    threads: 4
    resources:
         time   = 10,
         mem_mb = 6000
    shell:
        ''' 
            gatk --java-options "-Xms5g -Xmx5g" \
            GenomicsDBImport \
                --genomicsdb-workspace-path {output} \
                -L chr11:49584056-50592157 \
                --sample-name-map {input.gvcf_list} \
                --reader-threads 2 \
                -ip 500
        '''

rule genotype_gvcfs:
    input:
        ival_db = "{bucket}/wgs/pipeline/{ref}/{date}/import_gvcfs/unicorn_chr11_49584056-50592157",
    output:
        vcf = "{bucket}/wgs/pipeline/{ref}/{date}/genotype_gvcfs/unicorn_chr11_49584056-50592157/output.vcf.gz",
    params:
        ref_fasta = config["ref_fasta"]
    threads: 4
    resources:
         time   = 10,
         mem_mb = 6000
    shell:
        '''
            gatk --java-options "-Xmx5g -Xms5g" \
            GenotypeGVCFs \
                -R {params.ref_fasta} \
                -O {output.vcf} \
                -G StandardAnnotation \
                --only-output-calls-starting-in-intervals \
                -V gendb://{input.ival_db} \
                -L chr11:49584056-50592157
        '''
