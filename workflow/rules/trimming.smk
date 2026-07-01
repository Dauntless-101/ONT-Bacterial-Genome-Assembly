# Optional adapter trimming

import os

def get_trimming_input():
    """If trimming enabled, output from Porechop_ABI; else the raw reads."""
    if config["trimming"]["enabled"]:
        return "results/02_porechop/reads.trimmed.fastq.gz"
    else:
        # No trimming, chopper uses raw reads directly
        return config["reads"]["fastq"]

if config["trimming"]["enabled"]:
    rule porechop_abi:
        input:
            fastq = config["reads"]["fastq"]
        output:
            trimmed = "results/02_porechop/reads.trimmed.fastq.gz"
        log:
            "results/logs/porechop_abi.log"
        benchmark:
            "results/benchmarks/porechop_abi.benchmark"
        threads: config["threads"]
        conda:
            "environment.yml"
        shell:
            """
            porechop_abi -i {input.fastq} -o {output.trimmed} -t {threads} > {log} 2>&1
            """

# chopper filtering (always runs)
rule chopper:
    input:
        fastq = get_trimming_input()
    output:
        filtered = "results/03_chopper/reads.filtered.fastq.gz"
    params:
        min_qual = config["filtering"]["min_quality"],
        min_len = config["filtering"]["min_length"]
    log:
        "results/logs/chopper.log"
    benchmark:
        "results/benchmarks/chopper.benchmark"
    threads: config["threads"]
    conda:
        "environment.yml"
    shell:
        """
        chopper -q {params.min_qual} -l {params.min_len} -i {input.fastq} -o {output.filtered} > {log} 2>&1
        """
