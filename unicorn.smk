import pandas as pd
import os

#######################################
# local without BQSR ##################
#######################################

singularity: config['sif']
include: "src/utils.py"

# read inputs
units = pd.read_table(config['units'],dtype=str).set_index('readgroup_name',drop=False)

# get breed and sample name from units
breed = units['breed'].values[0]
sample_name = units['sample_name'].values[0]

# get sequence group intervals with unmapped and hc caller intervals
#sequence_grouping(config['bucket'],config['ref_dict'])
#intervals, = glob_wildcards(os.path.join(f"{config['bucket']}/seq_group/with_unmap","{interval}.tsv"))

rule all:
    input:
        # cram
       #expand(
       #    "{bucket}/wgs/{breed}/{sample_name}/{ref}/cram/{sample_name}.{ref}.cram",
       #    bucket=config['bucket'],
       #    breed=breed,
       #    sample_name=sample_name,
       #    ref=config["ref"],
       #    
       #),
        # gvcf
        expand(
            "{bucket}/wgs/{breed}/{sample_name}/{ref}/gvcf/{sample_name}.{ref}.g.vcf.gz",
            bucket=config['bucket'],
            breed=breed,
            sample_name=sample_name,
            ref=config["ref"],
            
        ),
        # multiqc
        expand(
            "{bucket}/wgs/{breed}/{sample_name}/{ref}/qc/multiqc_report.html",
            bucket=config['bucket'],
            breed=breed,
            sample_name=sample_name,
            ref=config["ref"],
            
        ),

# rules to include based on user setup
include: "rules/qc.smk"
include: "rules/bam.smk"
include: "rules/gvcf.smk"

