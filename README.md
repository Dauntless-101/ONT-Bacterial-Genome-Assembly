# ONT-Bacterial-Genome-Assembly

**A reproducible Snakemake workflow for bacterial genome assembly, polishing, quality assessment, and annotation from Oxford Nanopore sequencing reads.**

Introduction

`ONT-Bacterial-Genome-Assembly` is a production-grade pipeline that takes ONT FASTQ reads and produces a fully assembled, polished, and annotated bacterial genome. It is designed to be used by bioinformatics core facilities, open-source labs, and individual researchers who value reproducibility and software quality.

Every step is containerized, logged, benchmarked, and recorded — you get a final report, machine-readable provenance, and a citable result.

**Supported species:** E. coli, Pseudomonas,Staphylococcus, Salmonella and virtually any other bacterial genome.


Features

  **End-to-end automation** – reads to annotated genome with a single command
  **Reproducible** – pinned Conda environments, Docker & Apptainer containers
  **Self-documenting** – automatic software version recording and MultiQC report
  **Scalable** – configurable threads, genome size, and filtering
  **Modern tools** – Flye, Medaka, Bakta, chopper
  **Provenance** – every output file has a log, benchmark, and software versions
  **Optional steps** – adapter trimming disabled by default (for Dorado users)
  **Portable** – runs on laptops, clusters, and HPCs (with Apptainer)

Step‑by‑step
Step	Tool	                 Purpose

1	   LongQC	            Assess raw read quality

2	   Porechop_ABI	      Remove adapters (optional)

3	    chopper	          Filter by length and quality

4	    LongQC	          Assess filtered read quality

5	    Flye	            Long-read assembly

6	    Minimap2	        Align reads to draft assembly

7	    Racon	            Draft assembly polishing (3 rounds)

8	    Medaka	          Neural network polishing

9	    QUAST	            Assembly quality metrics

10	  BUSCO	            Genome completeness

11	  Bakta	            Structural and functional annotation

12	  MultiQC	          Aggregate all QC results

13	  Custom	          Final HTML report + assembly stats + software versions


    N --> O[Final HTML report + versions + stats]
