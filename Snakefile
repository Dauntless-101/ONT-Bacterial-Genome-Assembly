# Snakemake entry point for ONT-Bacterial-Genome-Assembly

configfile: "config.yaml"

# -----------------------------------------------------------------------------
# Include all workflow rules
# -----------------------------------------------------------------------------
include: "workflow/rules/qc.smk"
include: "workflow/rules/trimming.smk"
include: "workflow/rules/assembly.smk"
include: "workflow/rules/polishing.smk"
include: "workflow/rules/annotation.smk"
include: "workflow/rules/report.smk"

# -----------------------------------------------------------------------------
# Final targets
# -----------------------------------------------------------------------------
rule all:
    input:
        "results/report/final_report.html",
        "results/assembly_stats.tsv",
        "results/assembly_stats.json",
        "results/software_versions.yml",
