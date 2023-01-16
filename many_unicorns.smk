import os

# pipeline to joint genotype GVCFs

singularity: config['sif']

rule all:
    input:
        # vep'ed vcf
        expand(
            "{bucket}/wgs/pipeline/{ref}/{date}/annotate/vep/unicorn_chr11_49584056-50592157/joint_call.vep.vcf.gz", 
            bucket=config['bucket'],
            ref=config['ref'],
            date=config['date'],
        ),
        # multiqc report
        expand(
            "{bucket}/wgs/pipeline/{ref}/{date}/joint_qc/multiqc_report.html",
            bucket=config['bucket'],
            ref=config['ref'],
            date=config['date'],
        ),

include: "rules/genotype.smk"
include: "rules/vep.smk"
include: "rules/joint_qc.smk"

