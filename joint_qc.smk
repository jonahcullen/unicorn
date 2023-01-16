
rule bcftools_stats:
    input:
        final_vcf = "{bucket}/wgs/pipeline/{ref}/{date}/genotype_gvcfs/unicorn_chr11_49584056-50592157/output.vcf.gz",
    output:
        all_stats = "{bucket}/wgs/pipeline/{ref}/{date}/joint_qc/{ref}_{date}_cohort.vchk",
    params:
        ref_fasta = config['ref_fasta'],
        conda_env = config['conda_envs']['qc']
    threads: 1
    resources:
         time   = 10,
         mem_mb = 6000
    shell:
        '''
            bcftools stats \
                -F {params.ref_fasta} \
                -s - {input.final_vcf} \
                > {output.all_stats}
        '''

rule bcftools_plot:
    input:
        all_stats = "{bucket}/wgs/pipeline/{ref}/{date}/joint_qc/{ref}_{date}_cohort.vchk",
    output:
        summary = "{bucket}/wgs/pipeline/{ref}/{date}/joint_qc/{ref}_{date}_cohort/summary.pdf"
    params:
        prefix    = "{bucket}/wgs/pipeline/{ref}/{date}/joint_qc/{ref}_{date}_cohort",
        conda_env = config['conda_envs']['qc']
    threads: 1
    resources:
         time   = 10,
         mem_mb = 6000
    shell:
        '''
            plot-vcfstats \
                -p {params.prefix} \
                {input.all_stats}
        '''

rule qc_cohort:
    input:
        "{bucket}/wgs/pipeline/{ref}/{date}/joint_qc/{ref}_{date}_cohort.vchk",
        "{bucket}/wgs/pipeline/{ref}/{date}/joint_qc/{ref}_{date}_cohort/summary.pdf"
    output: 
        "{bucket}/wgs/pipeline/{ref}/{date}/joint_qc/multiqc_report.html"
    params:
        outdir = "{bucket}/wgs/pipeline/{ref}/{date}/joint_qc/"
    threads: 1
    resources:
        time   = 10,
        mem_mb = 12000
    shell:
        '''
            multiqc {wildcards.bucket} \
                --interactive \
                --force \
                -o {params.outdir}
        '''

