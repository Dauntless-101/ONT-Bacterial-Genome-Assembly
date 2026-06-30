# ONT-Bacterial-Genome-Assembly

 ONT-Bacterial-Genome-Assembly

[![Snakemake](https://img.shields.io/badge/snakemake-≥8.0-brightgreen.svg)](https://snakemake.github.io)
[![Docker](https://img.shields.io/badge/docker-ready-blue.svg)](https://www.docker.com)
[![Apptainer](https://img.shields.io/badge/apptainer-ready-blue.svg)](https://apptainer.org)
[![License](https://img.shields.io/badge/license-MIT-purple.svg)](LICENSE)
[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.XXXXXX-orange.svg)](https://doi.org/10.5281/zenodo.XXXXXX)
[![CI](https://github.com/<your-org>/ONT-Bacterial-Genome-Assembly/actions/workflows/test.yml/badge.svg)](https://github.com/<your-org>/ONT-Bacterial-Genome-Assembly/actions)

**A reproducible Snakemake workflow for assembling, polishing, evaluating, and annotating bacterial genomes from Oxford Nanopore sequencing reads.**

---

## Introduction

**ONT-Bacterial-Genome-Assembly** is a reproducible workflow for assembling bacterial genomes from Oxford Nanopore sequencing reads. Starting from raw FASTQ files, the pipeline performs quality control, optional adapter trimming, read filtering, *de novo* assembly, polishing, assembly evaluation, and genome annotation to produce a high-quality draft or complete bacterial genome.

The workflow is implemented in Snakemake and emphasises **reproducibility, portability, and transparency**. Every analysis step records software versions, runtime benchmarks, log files, and provenance information, making results easy to reproduce and audit.

Although optimised for bacterial genomes, the workflow is **not species‑specific** and has been designed to support a broad range of bacterial taxa, including *Escherichia coli*, *Pseudomonas*, *Staphylococcus*, *Salmonella*, and many others.

---

## Features

- End‑to‑end bacterial genome assembly from raw ONT FASTQ files  
- Single‑command execution – reads to annotated genome  
- Reproducible execution using Snakemake  
- Conda, Docker, and Apptainer support  
- Automatic software version tracking  
- Runtime benchmarking and detailed log files  
- Configurable filtering and polishing parameters  
- Optional adapter trimming (disabled by default)  
- Modern long‑read assembly and polishing tools  
- Comprehensive quality assessment and genome annotation  
- Aggregated MultiQC report and final HTML summary  

---

## Reproducibility

This workflow is built to ensure computational reproducibility:

- ✅ Pinned Conda environments for every rule  
- ✅ Docker and Apptainer containers available  
- ✅ Automatic recording of all software versions (`software_versions.yml`)  
- ✅ Runtime benchmarks for each step  
- ✅ Detailed log files per rule  
- ✅ Deterministic output directory structure  
- ✅ Checksum‑verified test dataset  

---

## Pipeline overview

```mermaid
flowchart TD
    A[Raw ONT FASTQ] --> B[LongQC]
    B --> C{Adapter trimming needed?}
    C -- No --> D[chopper read filtering]
    C -- Yes --> E[Porechop_ABI] --> D
    D --> F[LongQC]
    F --> G[Flye assembly]
    G --> H[Minimap2 mapping]
    H --> I[Racon polishing ×3]
    I --> J[Medaka polishing]
    J --> K[QUAST]
    J --> L[BUSCO]
    K --> M[Bakta annotation]
    L --> M
    M --> N[MultiQC]
    N --> O[Final HTML report + software versions + assembly stats]
Tool table
Step	Tool	Purpose / Output
1	LongQC	Assess raw read quality → QC report
2	Porechop_ABI	Remove adapters (only if trimming enabled) → trimmed FASTQ
3	chopper	Filter reads by length and quality → filtered FASTQ
4	LongQC	Assess filtered read quality → QC report
5	Flye	Long‑read de novo assembly → draft genome
6	Minimap2	Map reads to draft assembly → BAM
7	Racon	Draft polishing (3 rounds) → polished FASTA
8	Medaka	Neural‑network base‑level polishing → final assembly
9	QUAST	Assembly contiguity and correctness metrics → report
10	BUSCO	Genome completeness evaluation → completeness scores
11	Bakta	Structural and functional annotation → annotated genome (GFF3, GBK, etc.)
12	MultiQC	Aggregate all QC logs → interactive HTML report
Tool selection rationale
Why Flye?
Flye is one of the most widely adopted long‑read assemblers for bacterial genomes. It accurately resolves repetitive regions and frequently produces complete circular chromosomes. Its graph‑based approach handles ONT reads with high error tolerance.

Why Medaka?
Medaka improves base‑level accuracy using a neural‑network model trained specifically for Oxford Nanopore data. It is maintained directly by ONT and consistently outperforms other polishers on modern chemistries.

Why Bakta?
Bakta is actively maintained, faster, and more accurate than Prokka. It handles databases transparently and outputs standardised annotation files (GFF3, GBK, EMBL) that are directly usable in downstream analyses.

Why chopper?
chopper is a Rust‑based read filter that replaces NanoFilt. It is significantly faster, uses less memory, and is actively maintained — ideal for modern large ONT datasets.

Why Racon?
Racon provides fast, reference‑guided polishing that improves both contiguity and per‑base accuracy. Multiple rounds reliably refine draft assemblies before final Medaka polishing.

Repository structure
text
ONT-Bacterial-Genome-Assembly/
├── README.md
├── LICENSE
├── CITATION.cff
├── CHANGELOG.md
├── CONTRIBUTING.md
├── CODE_OF_CONDUCT.md
├── .gitignore
├── environment.yml
├── Dockerfile
├── Singularity.def
├── config.yaml
├── Snakefile
├── workflow/
│   ├── rules/
│   │   ├── qc.smk
│   │   ├── trimming.smk
│   │   ├── assembly.smk
│   │   ├── polishing.smk
│   │   ├── annotation.smk
│   │   └── report.smk
│   └── scripts/
│       ├── detect_model.py
│       └── write_versions.py
├── docs/
│   ├── installation.md
│   ├── workflow.md
│   ├── tools.md
│   ├── faq.md
│   └── troubleshooting.md
├── example_data/
├── tests/
├── resources/
├── results/
└── .github/
    └── workflows/
        └── test.yml
Requirements
Snakemake ≥ 8.0

Conda (Miniconda or Miniforge) or Docker or Apptainer

The pipeline automatically creates per‑rule Conda environments defined in workflow/rules/*.smk. Alternatively, you can use the provided Docker or Apptainer containers.

Installation
Using Conda (recommended for single machine)
bash
git clone https://github.com/<your-org>/ONT-Bacterial-Genome-Assembly.git
cd ONT-Bacterial-Genome-Assembly
conda env create -f environment.yml
conda activate ont-assembly
Using Docker
bash
docker build -t ont-bact-assembly .
docker run -v $(pwd):/data ont-bact-assembly snakemake --cores 8
Using Apptainer (HPC‑friendly)
bash
apptainer build ont-bact-assembly.sif Singularity.def
apptainer exec --bind $(pwd) ont-bact-assembly.sif snakemake --cores 16
Quick start
Edit config.yaml to point to your FASTQ file, adjust genome_size, and set threads.

Activate the environment (if using Conda) or run via container.

Execute the workflow:

bash
snakemake --use-conda --cores 8
Your results will be in results/. Open results/report/final_report.html to view the final summary, or inspect individual output folders.

What you’ll get: A polished, annotated genome, assembly statistics (TSV & JSON), a MultiQC report, and a self‑contained HTML report with all QC figures, tool versions, and runtime information.

Inputs
The workflow expects one or more gzip‑compressed FASTQ files of ONT reads. Modern Dorado and Guppy basecalling typically remove adapters during basecalling, so the pipeline disables adapter trimming by default. If your data still contains adapters, set trimming.enabled: true in config.yaml.

Configuration
All parameters are set in config.yaml. You should never need to edit the Snakemake rules themselves.

yaml
sample: ecoli

reads:
  fastq: example_data/ecoli.fastq.gz

assembly:
  genome_size: 5m

filtering:
  min_quality: 10
  min_length: 1000

trimming:
  enabled: false
  tool: porechop_abi          # only used if enabled: true

polishing:
  racon_rounds: 3
  medaka_model: r1041_e82_400bps_sup_v5.0.0    # fallback if auto‑detection fails

threads: 16

output: results
Medaka model auto‑detection: The pipeline attempts to detect the correct Medaka model from Dorado read headers. If that fails, it falls back to medaka_model.
To list available models, run: medaka tools list_models.

Outputs
text
results/
├── 01_longqc_raw/
├── 02_porechop/                     (only if trimming enabled)
├── 03_chopper/
├── 04_longqc_filtered/
├── 05_flye/
├── 06_mapping/
├── 07_racon/
├── 08_medaka/
├── 09_quast/
├── 10_busco/
├── 11_bakta/
├── 12_multiqc/
├── logs/                            (per‑rule log & benchmark files)
├── software_versions.yml
├── assembly_stats.tsv
├── assembly_stats.json
└── report/
    └── final_report.html
The final HTML report aggregates QUAST, BUSCO, LongQC, MultiQC, and includes an annotated assembly graph, runtime summary, and the exact software versions used.

Example dataset
A small E. coli ONT dataset is provided in example_data/. To run a quick test:

bash
snakemake --use-conda --cores 8
Expected runtime on a modern laptop: ~15–30 minutes. Results appear in results/.

Citation
If you use this pipeline in your research, please cite:

ONT-Bacterial-Genome-Assembly: A reproducible Snakemake workflow for ONT bacterial genome assembly and annotation.
Zenodo. DOI: 10.5281/zenodo.XXXXXX

We also strongly encourage citing the core tools employed (Flye, Medaka, Bakta, etc.). The automatically generated software_versions.yml lists every tool and version to simplify your methods section.

References
Flye: Kolmogorov et al. 2019, Nat. Biotechnol.

Medaka: ONT Research, github.com/nanoporetech/medaka

Bakta: Schwengers et al. 2021, Microbial Genomics

QUAST: Gurevich et al. 2013, Bioinformatics

BUSCO: Manni et al. 2021, Mol. Biol. Evol.

chopper: github.com/nanoporetech/chopper

License
This project is licensed under the MIT License — see the LICENSE file for details.

Contributing
We welcome contributions! Please see CONTRIBUTING.md and our Code of Conduct.

Contact
For questions, issues, or feature requests, please open an issue on GitHub or contact the maintainers directly at: taha.akerzoul@um5r.ac.ma


