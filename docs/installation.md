# Installation

**ONT-Bacterial-Genome-Assembly** can be installed and run using Conda, Docker, or Apptainer. All three methods produce identical results.

## 1. Using Conda (recommended for personal workstations)

```bash
# Clone the repository
git clone https://github.com/Dauntless-101/ONT-Bacterial-Genome-Assembly.git
cd ONT-Bacterial-Genome-Assembly

# Create the environment
conda env create -f environment.yml
conda activate ont-assembly

# Verify installation
snakemake --help

## 2. Using Docker
docker build -t ont-bact-assembly .
docker run -v $(pwd):/data ont-bact-assembly snakemake --cores 8

## 3. Using Apptainer (HPC‑friendly)
apptainer build ont-bact-assembly.sif Singularity.def
apptainer exec --bind $(pwd) ont-bact-assembly.sif snakemake --cores 16
