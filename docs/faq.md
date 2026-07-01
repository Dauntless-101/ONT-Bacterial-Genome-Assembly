# Frequently Asked Questions

### Q: Do I need to trim adapters?
By default, **no**. Modern Dorado and Guppy basecalling remove adapters automatically. If your reads still contain adapters, set `trimming.enabled: true` in `config.yaml`.

### Q: Which Medaka model should I use?
The pipeline tries to detect the correct model from your reads. If that fails, you can manually set it in `config.yaml`. Run `medaka tools list_models` inside the environment to see all available models.

### Q: How do I increase the memory or threads?
Edit `config.yaml`:

```yaml
threads: 32
For memory, if running with Docker/Apptainer, you may need to adjust the container memory limits. Snakemake will respect the threads setting.

### Q: Can I run this on a cluster?
Yes. Use Snakemake’s cluster profile. For example, with Slurm:

bash
snakemake --profile profiles/slurm
See the Snakemake documentation for creating profiles.

### Q: How do I cite this pipeline?
Please use the DOI in the CITATION.cff file:

ONT-Bacterial-Genome-Assembly – Zenodo. https://doi.org/10.5281/zenodo.21102519

Also cite the individual tools used; see software_versions.yml in your results for exact versions.

### Q: My assembly is fragmented. What can I do?
Check read coverage; aim for at least 50×.

Ensure the genome size estimate in config.yaml is approximately correct.

Increase the read filtering stringency (min_quality, min_length).

If you expect a single circular chromosome, check the Flye log for circularisation messages.

### Q: I found a bug or have a feature request
Please open an issue at github.com/Dauntless-101/ONT-Bacterial-Genome-Assembly/issues.

text

---

## File: `docs/troubleshooting.md`

```markdown
# Troubleshooting

## 1. Conda environment creation fails
- Try updating conda: `conda update -n base conda`
- Use mamba for faster resolution: `mamba env create -f environment.yml`
- If a package is missing, check its availability on conda-forge/bioconda.

## 2. Snakemake reports “MissingInputException”
- Ensure your FASTQ file path is correct in `config.yaml`.
- The file must exist and be readable.
- If using Docker/Apptainer, verify the volume mount.

## 3. Medaka auto‑detection fails
A warning will appear: “Using fallback Medaka model”. This is fine; the pipeline will still run. You may want to check that your reads contain Dorado basecaller headers. If not, manually set the correct model.

## 4. Out of memory errors
- Reduce the number of threads (`threads: 8`).
- Increase the memory allocated to your container or job.
- For Flye, you can add `--asm-coverage 50` (or similar) by editing the Snakefile rule; do this only if you have very high coverage.

## 5. BUSCO reports “lineage not found”
The pipeline uses `bacteria_odb10` by default. This dataset is downloaded automatically the first time BUSCO runs. If you are offline, you’ll need to pre‑download it using `busco --download bacteria_odb10`.

## 6. MultiQC report is empty
MultiQC needs to find supported log files. Check that LongQC, QUAST, and BUSCO ran successfully and produced output in the expected directories. If a step failed, MultiQC may have nothing to aggregate.

## 7. “FileNotFoundError” for example_data
If you don’t have a test dataset, download one:

```bash
bash scripts/download_test_data.sh
