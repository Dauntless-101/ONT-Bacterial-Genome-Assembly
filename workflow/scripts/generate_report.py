#!/usr/bin/env python3
"""Generate the final HTML report with embedded MultiQC, QUAST, BUSCO, and version info."""

import shutil
import os
import yaml
import json
from pathlib import Path

out = snakemake.output.report
sample = snakemake.params.sample

# Build a simple self-contained HTML
multiqc_rel = os.path.relpath(snakemake.input.multiqc, os.path.dirname(out))
busco_summary = snakemake.input.busco_summary
versions_yml = snakemake.input.versions
stats_json = snakemake.input.stats_json

# Read BUSCO short summary text
busco_text = Path(busco_summary).read_text()

with open(versions_yml) as f:
    versions = yaml.safe_load(f)

with open(stats_json) as f:
    stats = json.load(f)

# Simple HTML template
html = f"""<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ONT Assembly Report - {sample}</title>
    <style>
        body {{ font-family: Arial, sans-serif; margin: 20px; }}
        h1, h2 {{ color: #333; }}
        pre {{ background: #f4f4f4; padding: 10px; }}
        table {{ border-collapse: collapse; margin-bottom: 20px; }}
        td, th {{ border: 1px solid #ddd; padding: 8px; }}
        th {{ background-color: #f2f2f2; }}
    </style>
</head>
<body>
    <h1>ONT-Bacterial-Genome-Assembly Report</h1>
    <p>Sample: <strong>{sample}</strong></p>
    
    <h2>Assembly Statistics</h2>
    <table>
        <tr><th>Metric</th><th>Value</th></tr>
        {''.join(f'<tr><td>{k}</td><td>{v}</td></tr>' for k, v in stats.items())}
    </table>
    
    <h2>BUSCO Assessment</h2>
    <pre>{busco_text}</pre>
    
    <h2>Software Versions</h2>
    <table>
        <tr><th>Tool</th><th>Version</th></tr>
        {''.join(f'<tr><td>{tool}</td><td>{ver}</td></tr>' for tool, ver in versions.items())}
    </table>
    
    <h2>MultiQC Report</h2>
    <p>See the <a href="{multiqc_rel}" target="_blank">MultiQC report</a> for interactive QC plots.</p>
    
    <h2>QUAST Results</h2>
    <p>Detailed assembly metrics are in the <a href="../09_quast/report.html" target="_blank">QUAST report</a>.</p>
</body>
</html>
"""

with open(out, 'w') as f:
    f.write(html)
