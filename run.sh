#!/bin/bash
set -euo pipefail

echo "============================================"
echo " ONT-Bacterial-Genome-Assembly"
echo "============================================"
echo ""

ENV_NAME="ont-assembly"
if ! conda env list | grep -q "^${ENV_NAME} "; then
    echo "Conda environment '${ENV_NAME}' not found."
    echo "Creating it from environment.yml..."
    conda env create -f environment.yml
    echo "Environment created. Activate it with: conda activate ${ENV_NAME}"
    exit 0
fi

if [[ "${CONDA_DEFAULT_ENV:-}" != "${ENV_NAME}" ]]; then
    echo "Please activate the Conda environment first:"
    echo "  conda activate ${ENV_NAME}"
    echo "Then re-run this script."
    exit 1
fi

# Check that the FASTQ file exists
FASTQ=$(grep 'fastq:' config.yaml | awk '{print $2}' | tr -d '"')
if [ ! -f "$FASTQ" ]; then
    echo "ERROR: Input FASTQ file '$FASTQ' not found."
    echo "Update config.yaml to point to your reads."
    exit 1
fi

echo "Starting the pipeline..."
snakemake \
    --cores all \
    --printshellcmds \
    --use-conda \
    --rerun-incomplete \
    --keep-going

echo ""
echo "Pipeline finished. Results are in results/"
