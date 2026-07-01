# Quality assessment and annotation

rule quast:
    input:
        assembly = "results/08_medaka/polished.fasta"
    output:
        report = "results/09_quast/report.tsv"
    params:
        outdir = "results/09_quast"
    log:
        "results/logs/quast.log"
    benchmark:
        "results/benchmarks/quast.benchmark"
    threads: config["threads"]
    conda:
        "environment.yml"
    shell:
        """
        quast.py {input.assembly} -o {params.outdir} -t {threads} --silent > {log} 2>&1
        """

rule busco:
    input:
        assembly = "results/08_medaka/polished.fasta"
    output:
        short_summary = "results/10_busco/short_summary.txt"
    params:
        outdir = "results/10_busco",
        lineage = "bacteria_odb10"   # you can make this configurable later
    log:
        "results/logs/busco.log"
    benchmark:
        "results/benchmarks/busco.benchmark"
    threads: config["threads"]
    conda:
        "environment.yml"
    shell:
        """
        busco -i {input.assembly} -o {params.outdir} -l {params.lineage} -m genome -c {threads} --offline > {log} 2>&1
        """

rule bakta:
    input:
        assembly = "results/08_medaka/polished.fasta"
    output:
        gff = "results/11_bakta/annotation.gff3",
        genbank = "results/11_bakta/annotation.gbk"
    params:
        outdir = "results/11_bakta"
    log:
        "results/logs/bakta.log"
    benchmark:
        "results/benchmarks/bakta.benchmark"
    threads: config["threads"]
    conda:
        "environment.yml"
    shell:
        """
        bakta {input.assembly} --output {params.outdir} --threads {threads} > {log} 2>&1
        """
