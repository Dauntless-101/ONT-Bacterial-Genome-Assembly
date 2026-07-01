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


#### Test the installation with a small E. coli test dataset is available:

bash
bash scripts/download_test_data.sh
Then run the pipeline:

bash
snakemake --use-conda --cores 8
Expected runtime is ~15–30 minutes.

text

---

## File: `docs/workflow.md`

```markdown
# Workflow description

This document describes each step of the **ONT-Bacterial-Genome-Assembly** pipeline.

## 1. LongQC (raw reads)
Tool: [LongQC](https://github.com/sfragkoulis/LongQC)
Assesses read quality: length distribution, quality scores, GC bias, and potential contamination. Output is a report in `results/01_longqc_raw/`.

## 2. Optional adapter trimming
Tool: [Porechop_ABI](https://github.com/bonsai-team/Porechop_ABI)
If enabled in `config.yaml` (`trimming.enabled: true`), adapter sequences are removed. By default, it is **disabled** because Dorado/Guppy usually trims adapters during basecalling.

## 3. chopper read filtering
Tool: [chopper](https://github.com/nanoporetech/chopper)
Filters reads by minimum quality (default Q≥10) and minimum length (default ≥1000 bp). This produces `results/03_chopper/reads.filtered.fastq.gz`.

## 4. LongQC (filtered reads)
A second LongQC run on the filtered reads for comparison.

## 5. Flye assembly
Tool: [Flye](https://github.com/fenderglass/Flye)
De novo long‑read assembly using a repeat graph. Produces a draft genome in `results/05_flye/assembly.fasta`.

## 6. Minimap2 alignment
Tool: [minimap2](https://github.com/lh3/minimap2)
Maps the filtered reads back to the draft assembly, generating a sorted, indexed BAM in `results/06_mapping/`.

## 7. Racon polishing (×3)
Tool: [Racon](https://github.com/lbcb-sci/racon)
Runs three rounds of reference‑guided polishing using the mapped reads. Each round’s output is in `results/07_racon/roundN_polished.fasta`.

## 8. Medaka polishing
Tool: [Medaka](https://github.com/nanoporetech/medaka)
Neural‑network base‑level polishing. The model is auto‑detected from read headers when possible, otherwise falls back to the model in `config.yaml`. Final assembly: `results/08_medaka/polished.fasta`.

## 9. QUAST evaluation
Tool: [QUAST](https://github.com/ablab/quast)
Calculates assembly contiguity (N50, L50, largest contig, number of contigs) and correctness statistics.

## 10. BUSCO assessment
Tool: [BUSCO](https://busco.ezlab.org)
Evaluates genome completeness using the `bacteria_odb10` set of single‑copy orthologs.

## 11. Bakta annotation
Tool: [Bakta](https://github.com/oschwengers/bakta)
Structural and functional annotation. Outputs GFF3, GBK, and other annotation files in `results/11_bakta/`.

## 12. MultiQC
Tool: [MultiQC](https://multiqc.info)
Aggregates all LongQC, QUAST, and BUSCO reports into one interactive HTML file: `results/12_multiqc/multiqc_report.html`.

## 13. Final report & provenance
A self‑contained HTML report (`results/report/final_report.html`) embeds MultiQC, assembly statistics, software versions, and a summary table. Additionally, the pipeline records `software_versions.yml`, `assembly_stats.tsv`, and `assembly_stats.json` in the results folder.
