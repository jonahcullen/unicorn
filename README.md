# unicorn
eq**U**ine ge**N**et**I**cs **CO**ntaine**R**ized pipeli**N**e

This repo contains the steps required to setup a snakemake environment in order to process FASTQs to GVCFs and ultimately a joint genotyped VCF, all using a Singularity container.

## Dependencies

- [Python](https://www.python.org/)
- [Mamba](https://github.com/mamba-org/mamba) or [Conda](https://conda.io/)
- [Snakemake](https://snakemake.readthedocs.io/)
- Miscellaneous python modules [pyaml](https://pyyaml.org/), [wget](https://bitbucket.org/techtonik/python-wget/), and [xlsxwriter](https://xlsxwriter.readthedocs.io/)
- [Apptainer/Singularity](https://apptainer.org/)
- [MinIO Client](https://min.io/docs/minio/linux/reference/minio-mc.html)

The `unicorn` Singularity container includes the following tools:
- [Placeholder]

## Initial setup

Setup will be dependent on whether you will be using resources provided by your home institution (i.e. `ssh` into your HPC) (A) or spinning up an Amazon instance (B).

### (A) Home institution HPC

**1. Install dependencies**

If you do not have `conda` already installed, the Snakemake developers **recommend** to install via [Mambaforge](https://github.com/conda-forge/miniforge#mambaforge).

```
# download Mambaforge installer (assuming Unix-like platform)
wget "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh"
bash Mambaforge-$(uname)-$(uname -m).sh

# updata Mamba
mamba update mamba -c conda-forge

# create a Snakemake environment which includes all Snakemake dependencies in
# addition to the miscellaneous modules above
mamba create \
    -c conda-forge -c bioconda \
    -n snakemake \ # name of the environment
    snakemake pyaml wget xlsxwriter
```

Alternatively, if you are already familiar with `conda` and creating environments, it is suggested to install `mamba` in your base environment and use that to build your environment.

```
# install mamba
conda install -n base -c conda-forge mamba

# create a Snakemake environment
mamba create \
    -c conda-forge -c bioconda \
    -n snakemake \ # name of the environment
    snakemake pyaml wget xlsxwriter
```

**2. Download processed samples**

As part of the workshop, we'll be processing only one sample (AH4) as the other three (AH1, AH2, and AH3) have already been completed. The archive below also contains the FASTQs for AH4.

```
wget https://s3.msi.umn.edu/wags/samples.tar.gz
tar -xzvf samples.tar.gz
```

**3. Clone this repo**

```
git clone https://github.com/jonahcullen/unicorn.git && cd unicorn
```

**2. Download the container**

Due to the size of the Equine genome and associated indices included in the container (and depending on your internet speed) this should take ~2 minutes.

```
wget https://s3.msi.umn.edu/wags/unicorn.sif
```

### (B) Amazon instance

- from where will they get the .pem?
link to Jillians excellent instructions for PCs
@Ted can you put instructions here for Mac?

## Processing FASTQs to GVCFs for AH4

Once the initial setup has been completed, we are ready to process the FASTQs for AH4! First activate your snakemake environment with either `source activate snakemake` or `conda activate snakemake` (JILLIAN can you let me know which one works on MSI vs Amazon? It will depend and I cannot remember which is which between the two). In order to start pipeline, execute the following

```
snakemake -s unicorn.smk \
    --use-singularity \
    --singularity-args "-B $PWD" \
    --configfile AH4_goldenPath_config.yaml \
    --cores 8
```

This should take ~8 minutes.
