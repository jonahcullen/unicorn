import pandas as pd

def get_fastq(wildcards):
    '''
    Get fastq files of given sample-unit.
    '''
    fastqs = units.loc[(wildcards.readgroup_name), ['fastq_1', 'fastq_2']].dropna()
    
    return {'r1': fastqs.fastq_1, 'r2': fastqs.fastq_2}

