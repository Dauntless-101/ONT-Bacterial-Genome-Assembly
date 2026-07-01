# Tool selection rationale

We chose each tool based on **accuracy**, **maintenance**, **speed**, and **reproducibility**.

| Tool | Why |
|------|-----|
| **LongQC** | Purpose‑built for long reads; produces standard metrics. |
| **chopper** | Modern Rust‑based filter; much faster than NanoFilt and actively maintained. |
| **Porechop_ABI** | Actively maintained fork of Porechop; used only when adapters remain in reads. |
| **Flye** | Graph‑based long‑read assembler; excellent at resolving repeats and producing circular genomes. |
| **minimap2** | Fast, accurate long‑read mapper; industry standard. |
| **Racon** | Lightweight, reference‑guided draft polisher; three rounds robustly improve assembly. |
| **Medaka** | Neural‑network polisher trained specifically for ONT data; maintained by ONT. |
| **QUAST** | Standard assembly evaluation tool; reports contiguity and correctness. |
| **BUSCO** | Quantifies genome completeness using universally conserved genes; gold standard for quality. |
| **Bakta** | Actively maintained annotation tool; faster and more accurate than Prokka; outputs standardised formats. |
| **MultiQC** | Aggregates logs from multiple tools into one interactive report. |
