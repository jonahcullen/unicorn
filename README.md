# unicorn
eq**U**ine ge**N**et**I**cs **CO**ntaine**R**ized pipeli**N**e

This repo contains the steps required to setup a snakemake environment in order to process FASTQs to GVCFs and ultimately a joint genotyped VCF, all using a Singularity container.

## Dependencies

- [Python](https://www.python.org/)
- [Mamba](https://github.com/mamba-org/mamba) or [Conda](https://conda.io/)
- [Snakemake](https://snakemake.readthedocs.io/)
- [Apptainer/Singularity](https://apptainer.org/)

The `unicorn` Singularity container includes the following tools:
- [Placeholder]

## Initial setup

Setup will be dependent on whether you will be using resources provided by your home institution (i.e. `ssh` into your HPC) (A) or spinning up an Amazon instance (B).

### (A) Home institution HPC

**1. Install dependencies**

If you do not have `conda` already installed, the Snakemake developers **recommend** to install via [Mambaforge](https://github.com/conda-forge/miniforge#mambaforge).

```
# download Mambaforge installer (assuming Unix-like platform) (~5 minutes)
wget "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh"
bash Mambaforge-$(uname)-$(uname -m).sh

# to use mamba either log out and log back in or source your configuration file as
source ~/.bashrc

# updata Mamba
mamba update mamba -c conda-forge

# create a Snakemake environment, here named snakemake (`-n snakemake`) which includes all Snakemake dependencies (~5 minutes)
mamba create -c conda-forge -c bioconda -n snakemake snakemake
```

Alternatively, if you are already familiar with `conda` and creating environments, it is suggested to install `mamba` in your base environment and use that to build your environment.

```
# install mamba
conda install -n base -c conda-forge mamba

# create a Snakemake environment
mamba create -c conda-forge -c bioconda -n snakemake snakemake 
```

**2. Download sample data**

As part of the workshop, we'll be processing only one sample (AH4) as the other three (AH1, AH2, and AH3) have already been completed. The archive below also contains the FASTQs for AH4.

```
wget https://s3.msi.umn.edu/wags/samples.tar.gz
tar -xzvf samples.tar.gz
```

**3. Clone this repo**

```
git clone https://github.com/jonahcullen/unicorn.git
```

**4. Download the container**

Due to the size of the Equine genome and associated indices included in the container (and depending on your internet speed) this should take ~2 minutes.

```
wget https://s3.msi.umn.edu/wags/unicorn.sif
```

### (B) Amazon instance

**1. Download Instance Key**

Downloading the key can be done by copying the command below into a browser's address bar.

```
wget https://s3.msi.umn.edu/wags/EquineGenetics.pem
```

**2. Open the Instance**

Opening the instance will be different for PC users and Mac users

**PC Users**

PC users will need to use PuTTY and the associated PuTTYgen to start the instance. PuTTY version 0.76.0 or higher is necessary. The link below can be used to download the most recent version of the 64-bit x86 Windows installer. 

[Download PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)

After PuTTY is downloaded follow the instructions linked below to start the instance and finish set up.

[PC Instance Instructions](https://docs.google.com/document/d/e/2PACX-1vSxbIYY_2nD8KocEyIcnIzIIiYJBD6Ztj4TLod2Pytqm1Y-Qxgh6vw3bK0KNzbxbQ/pub)

**MAC Users**

@Jonah or Ted: Please check my instructions :)

In a terminal window, navigate to the directory containing the EquineGenetics.pem file. 

```
chmod 600 EquineGenetics.pem
ssh -i "EquineGenetics.pem" root@{selectedInstanceIP}
```
The selected IP address should be from the list of available instances. 

**3. Download processed samples**

As part of the workshop, we'll be processing only one sample (AH4) as the other three (AH1, AH2, and AH3) have already been completed. The archive below also contains the FASTQs for AH4.

```
wget https://s3.msi.umn.edu/wags/samples.tar.gz
tar -xzvf samples.tar.gz
```

**4. Clone this repo**

```
git clone https://github.com/jonahcullen/unicorn.git
```

**5. Download the container**

Due to the size of the Equine genome and associated indices included in the container (and depending on your internet speed) this should take ~2 minutes.

```
wget https://s3.msi.umn.edu/wags/unicorn.sif
```

## Processing FASTQs to GVCFs for AH4


Once the initial setup has been completed, we are ready to process the FASTQs for AH4! First activate your snakemake environment with `source activate snakemake`. In order to start the pipeline, execute the following

```
snakemake -s ./unicorn/unicorn.smk \
    --use-singularity \
    --singularity-args "-B $PWD" \
    --configfile ./unicorn/AH4_goldenPath_config.yaml \
    --cores 8
```

This should take ~8 minutes.
