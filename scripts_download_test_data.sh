#!/bin/bash
# Download a small E. coli ONT dataset for testing.
# This script fetches the ZymoBIOMICS E. coli ONT read set (~50 MB).

URL="https://s3.amazonaws.com/zymo-files/BioPool/ZymoBIOMICS.STD.EcoliONTDemo.fastq.gz"
OUTFILE="example_data/ecoli.fastq.gz"

echo "Downloading test dataset..."
mkdir -p example_data
wget -O "$OUTFILE" "$URL" || curl -o "$OUTFILE" "$URL"

echo "Test data saved to $OUTFILE"

#Make it executable with chmod +x scripts/download_test_data.sh
