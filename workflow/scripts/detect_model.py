#!/usr/bin/env python3
"""Detect Medaka model from Dorado read headers, with fallback."""

import sys
import gzip
import re

def detect_medaka_model(reads, fallback=None):
    """
    Scan FASTQ headers for Dorado's model tag. If found, return Medaka model name.
    Otherwise, return the fallback.
    """
    model = fallback
    # Dorado headers often contain 'model_version_id=' followed by a model name.
    pattern = re.compile(rb'model_version_id=([^\s]+)')
    try:
        with gzip.open(reads, 'rb') if reads.endswith('.gz') else open(reads, 'rb') as fh:
            for i, line in enumerate(fh):
                if i > 10000:  # check first 10k lines
                    break
                if line.startswith(b'@'):
                    match = pattern.search(line)
                    if match:
                        model_str = match.group(1).decode()
                        # Convert Dorado model string to Medaka model name
                        # Example: 'dna_r10.4.1_e8.2_400bps_sup@v4.2.0' -> r1041_e82_400bps_sup_v4.2.0
                        medaka_name = model_str.replace('dna_r10.4.1_e8.2', 'r1041_e82').replace('@', '_')
                        print(f"Auto-detected Medaka model: {medaka_name}", file=sys.stderr)
                        return medaka_name
    except Exception as e:
        print(f"Error detecting Medaka model: {e}", file=sys.stderr)
    print(f"Using fallback Medaka model: {fallback}", file=sys.stderr)
    return fallback

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python detect_model.py <reads.fastq.gz> <fallback_model>")
        sys.exit(1)
    model = detect_medaka_model(sys.argv[1], sys.argv[2])
    print(model)
