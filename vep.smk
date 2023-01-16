
rule vep_by_interval:
    input:
        vcf = "{bucket}/wgs/pipeline/{ref}/{date}/genotype_gvcfs/unicorn_chr11_49584056-50592157/output.vcf.gz",
    output:
        recal_vep      = "{bucket}/wgs/pipeline/{ref}/{date}/final_gather/vep/unicorn_chr11_49584056-50592157/joint_call.vep.vcf.gz", 
        recal_vep_tbi  = "{bucket}/wgs/pipeline/{ref}/{date}/final_gather/vep/unicorn_chr11_49584056-50592157/joint_call.vep.vcf.gz.tbi", 
        recal_vep_html = "{bucket}/wgs/pipeline/{ref}/{date}/final_gather/vep/unicorn_chr11_49584056-50592157/joint_call.vep.vcf_summary.html", 
    params:
        out_name = lambda wildcards, output: os.path.splitext(output.recal_vep)[0],
        ref_fasta = config['ref_fasta'],
        ref_gtf   = config['ref_gtf']
    threads: 6
    resources:
         time   = 720,
         mem_mb = 60000
    shell:
        '''
            set -e

            source activate ensembl-vep

            vep \
                -i {input.vcf} \
                -o {params.out_name} \
                --gtf {params.ref_gtf} \
                --fasta {params.ref_fasta} \
                --fork 4 \
                --everything \
                --force_overwrite \
                --vcf \
                --dont_skip

            bgzip --threads 6 -c {params.out_name} > {output.recal_vep}
            tabix -p vcf {output.recal_vep}
        '''

