#!/usr/bin/env python3
"""Compute assembly statistics from QUAST and BUSCO and save as TSV and JSON."""

import pandas as pd
import json
import re

quast_file = snakemake.input.quast_tsv
busco_file = snakemake.input.busco_summary

# Parse QUAST
quast = pd.read_csv(quast_file, sep='\t', index_col=0).squeeze()

# Parse BUSCO
busco_complete = 0
busco_total = 0
with open(busco_file) as f:
    for line in f:
        m = re.search(r'C:(\d+\.?\d*)%\[S:(\d+\.?\d*)%,D:(\d+\.?\d*)%\],F:(\d+\.?\d*)%,M:(\d+\.?\d*)%,n:(\d+)', line)
        if m:
            busco_complete = float(m.group(1))
            busco_total = int(m.group(6))
            break

stats = {
    "genome_size_bp": quast.get("# contigs >= 0 bp", "N/A"),
    "contigs": quast.get("# contigs", "N/A"),
    "largest_contig_bp": quast.get("Largest contig", "N/A"),
    "N50_bp": quast.get("N50", "N/A"),
    "L50": quast.get("L50", "N/A"),
    "GC_percent": quast.get("GC (%)", "N/A"),
    "BUSCO_complete_percent": busco_complete,
    "BUSCO_total_orthologs": busco_total,
}

df = pd.DataFrame([stats])
df.to_csv(snakemake.output.tsv, sep='\t', index=False)
with open(snakemake.output.json, 'w') as f:
    json.dump(stats, f, indent=2)
