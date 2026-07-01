# QC rules: LongQC on raw and filtered reads

rule longqc_raw:
    input:
        fastq = config["reads"]["fastq"]
    output:
        directory("results/01_longqc_raw")
    log:
        "results/logs/longqc_raw.log"
    benchmark:
        "results/benchmarks/longqc_raw.benchmark"
    threads: config["threads"]
    conda:
        "environment.yml"
    shell:
        """
        longqc {input.fastq} -o {output} -t {threads} > {log} 2>&1
        """

rule longqc_filtered:
    input:
        fastq = "results/03_chopper/reads.filtered.fastq.gz" if not config["trimming"]["enabled"] else "results/03_chopper/reads.filtered.fastq.gz"  # chopper output always
    output:
        directory("results/04_longqc_filtered")
    log:
        "results/logs/longqc_filtered.log"
    benchmark:
        "results/benchmarks/longqc_filtered.benchmark"
    threads: config["threads"]
    conda:
        "environment.yml"
    shell:
        """
        longqc {input.fastq} -o {output} -t {threads} > {log} 2>&1
        """
