#!/usr/bin/env python3
"""Record exact software versions of tools used."""

import subprocess
import yaml
import sys

tools = {
    "flye": "flye --version 2>&1",
    "minimap2": "minimap2 --version 2>&1",
    "samtools": "samtools version 2>&1",
    "racon": "racon --version 2>&1",
    "medaka": "medaka --version 2>&1",
    "quast": "quast.py --version 2>&1",
    "busco": "busco --version 2>&1",
    "bakta": "bakta --version 2>&1",
    "multiqc": "multiqc --version 2>&1",
    "chopper": "chopper --version 2>&1",
    "longqc": "longqc --version 2>&1",
    "snakemake": "snakemake --version 2>&1",
}

versions = {}
for name, cmd in tools.items():
    try:
        res = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        version_str = res.stdout.strip().split('\n')[0] if res.stdout.strip() else res.stderr.strip().split('\n')[0]
        versions[name] = version_str
    except Exception:
        versions[name] = "not_found"

with open(snakemake.output.versions, 'w') as f:
    yaml.dump(versions, f, default_flow_style=False)
