# Assembly with Flye and mapping with Minimap2

rule flye:
    input:
        fastq = "results/03_chopper/reads.filtered.fastq.gz"
    output:
        assembly = "results/05_flye/assembly.fasta",
        graph = "results/05_flye/assembly_graph.gfa"
    params:
        genome_size = config["assembly"]["genome_size"]
    log:
        "results/logs/flye.log"
    benchmark:
        "results/benchmarks/flye.benchmark"
    threads: config["threads"]
    conda:
        "environment.yml"
    shell:
        """
        flye --nano-raw {input.fastq} \
             --genome-size {params.genome_size} \
             --out-dir results/05_flye \
             --threads {threads} > {log} 2>&1
        """

rule minimap2:
    input:
        assembly = "results/05_flye/assembly.fasta",
        reads = "results/03_chopper/reads.filtered.fastq.gz"
    output:
        bam = "results/06_mapping/reads.mapped.bam"
    params:
        # sort and index in one step
        samtools_sort = "-@ {threads} -o {output.bam}"
    log:
        "results/logs/minimap2.log"
    benchmark:
        "results/benchmarks/minimap2.benchmark"
    threads: config["threads"]
    conda:
        "environment.yml"
    shell:
        """
        minimap2 -ax map-ont -t {threads} {input.assembly} {input.reads} | \
        samtools sort {params.samtools_sort} - > {log} 2>&1
        samtools index {output.bam}
        """
