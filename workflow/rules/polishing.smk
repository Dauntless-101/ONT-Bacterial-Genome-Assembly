# Polishing: Racon (3 rounds) and Medaka

def racon_round_input(round_num):
    """Return the input assembly for a given Racon round."""
    if round_num == 1:
        return "results/05_flye/assembly.fasta"
    else:
        return f"results/07_racon/round{round_num-1}_polished.fasta"

def racon_round_output(round_num):
    return f"results/07_racon/round{round_num}_polished.fasta"

racon_rounds = config["polishing"]["racon_rounds"]

for i in range(1, racon_rounds + 1):
    rule_name = f"racon_round{i}"
    rule:
        name: rule_name
        input:
            assembly = racon_round_input(i),
            bam = "results/06_mapping/reads.mapped.bam",
            reads = "results/03_chopper/reads.filtered.fastq.gz"
        output:
            assembly = racon_round_output(i)
        log:
            f"results/logs/racon_round{i}.log"
        benchmark:
            f"results/benchmarks/racon_round{i}.benchmark"
        threads: config["threads"]
        conda:
            "environment.yml"
        shell:
            """
            racon -t {threads} {input.reads} {input.bam} {input.assembly} > {output.assembly} 2> {log}
            """

rule medaka:
    input:
        assembly = f"results/07_racon/round{racon_rounds}_polished.fasta",
        reads = "results/03_chopper/reads.filtered.fastq.gz"
    output:
        final = "results/08_medaka/polished.fasta"
    params:
        model = None,  # will be set below
    log:
        "results/logs/medaka.log"
    benchmark:
        "results/benchmarks/medaka.benchmark"
    threads: config["threads"]
    conda:
        "environment.yml"
    run:
        # Attempt auto-detection of Medaka model
        from workflow.scripts.detect_model import detect_medaka_model
        model = detect_medaka_model(
            reads=input.reads,
            fallback=config["polishing"]["medaka_model"]
        )
        shell(f"""
            medaka_consensus -i {input.reads} \
                             -d {input.assembly} \
                             -o results/08_medaka \
                             -m {model} \
                             -t {threads} > {log} 2>&1
            cp results/08_medaka/consensus.fasta {output.final}
        """)
