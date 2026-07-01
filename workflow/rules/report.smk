# Aggregation, version recording, and final report

rule multiqc:
    input:
        dirs = [
            "results/01_longqc_raw",
            "results/04_longqc_filtered",
            "results/09_quast",
            "results/10_busco"
        ]
    output:
        report = "results/12_multiqc/multiqc_report.html"
    params:
        outdir = "results/12_multiqc"
    log:
        "results/logs/multiqc.log"
    benchmark:
        "results/benchmarks/multiqc.benchmark"
    conda:
        "environment.yml"
    shell:
        """
        multiqc -f -o {params.outdir} {input.dirs} > {log} 2>&1
        """

rule software_versions:
    input:
        assembly = "results/08_medaka/polished.fasta",
        bam = "results/06_mapping/reads.mapped.bam"
    output:
        versions = "results/software_versions.yml"
    log:
        "results/logs/software_versions.log"
    conda:
        "environment.yml"
    script:
        "workflow/scripts/write_versions.py"

rule assembly_stats:
    input:
        quast_tsv = "results/09_quast/report.tsv",
        busco_summary = "results/10_busco/short_summary.txt",
        versions = "results/software_versions.yml"
    output:
        tsv = "results/assembly_stats.tsv",
        json = "results/assembly_stats.json"
    log:
        "results/logs/assembly_stats.log"
    conda:
        "environment.yml"
    script:
        "workflow/scripts/assembly_stats.py"

rule final_report:
    input:
        multiqc = "results/12_multiqc/multiqc_report.html",
        quast_dir = "results/09_quast",
        busco_summary = "results/10_busco/short_summary.txt",
        versions = "results/software_versions.yml",
        stats_json = "results/assembly_stats.json"
    output:
        report = "results/report/final_report.html"
    params:
        sample = config["sample"]
    log:
        "results/logs/final_report.log"
    conda:
        "environment.yml"
    script:
        "workflow/scripts/generate_report.py"
