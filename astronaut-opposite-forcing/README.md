# astronaut-opposite-forcing

An R pipeline for **spaceflight oncogenic biomarker discovery** and **transcriptomic reversal ("opposite-forcing") drug screening**.

This pipeline re-discovers the spaceflight-associated oncogenic biomarker signature across human and rodent NASA OSDR RNA-seq datasets, screens LINCS L1000 drug perturbation signatures for compounds that reverse the signature (opposite forcing), annotates top reversal hits with drug-target-indication context, maps the biomarker signature to disease phenotypes, and flags nutraceutical candidates among the top reversal compounds as preparation for a deferred vegan-recipe optimization step.

It is a companion to (and R reimplementation of) the Python discovery repo [`astronaut-oncogene-biomarkers`](https://github.com/dr-richard-barker/astronaut-oncogene-biomarkers), whose S2 cross-study meta-signature is imported here as a cross-validation reference.

---

## What "opposite forcing" means

An **opposite-forcing** compound is one whose transcriptomic perturbation signature is *anti-correlated* with the disease (here, spaceflight oncogenic) signature — i.e., it downregulates genes that spaceflight upregulates, and vice versa. We quantify this with a tau-analog connectivity score computed against LINCS L1000 GEO drug perturbation signatures. A strongly negative tau (tau < -50) indicates a candidate reversal agent.

---

## Pipeline overview

| Step | Script | What it does |
|---|---|---|
| 01 | `scripts/01_OSD_query.R` | Download 24 OSDR studies (11 human + 13 rodent); also clones this repository, whose JAXA data are not used downstream |
| 02 | `scripts/02_biomarker_identification.R` | Per-study DESeq2 (padj<0.05, \|log2FC\|>1) + metafor random-effects meta-analysis + oncogene union intersection |
| 03 | `scripts/03_drug_screening.R` | LINCS tau-analog reversal scoring + Broad Drug Repurposing Hub + PrimeKG drug context + tissue stratification |
| 04 | `scripts/04_enrichment.R` | PrimeKG disease-gene hypergeometric enrichment + Open Targets API disease associations |
| 05 | `scripts/05_nutraceutical_flags.R` | Flag nutraceuticals among top-50 reversal hits (curated lexicon + LINCS GMT + Broad) |
| 06 | `scripts/06_figures_F1_F2.R` | Dataset panel overview (F1) + per-study QC PCA (F2) |
| 07 | `scripts/07_gene_level_reversal.R` | Gene-level reversal of oncogenic biomarkers by flavonoids (T13, F11, F12) |

Helper functions live in `R/` (sourced by the scripts):
- `osdr_client.R` — OSDR API client (httr/jsonlite)
- `orthologs.R` — mouse-to-human ortholog mapping via biomaRt
- `oncogene_union.R` — COSMIC CGC (try open) + OncoKB + KEGG + MSigDB C6 + curated
- `lincs_reversal.R` — tau-analog WCS computation from datalake GEO z-score signatures
- `primekg.R` — PrimeKG edge filtering + hypergeometric disease enrichment
- `opentargets.R` — Open Targets GraphQL client
- `validation.R` — R signature vs Python S2 concordance

---

## Quick start

```bash
# Clone
git clone https://github.com/dr-richard-barker/Astronaut_flavenoids_and_biomarkers.git
cd Astronaut_flavenoids_and_biomarkers/astronaut-opposite-forcing

# Restore R environment (renv)
install.packages("renv")
renv::restore()

# Run the full pipeline (downloads ~1.4 GB OSDR data on first run)
Rscript run_all.R

# Or run a single step
Rscript run_all.R --only 03

# Or resume from a step
Rscript run_all.R --from 04
```

### Prerequisites

- **R 4.4+** with packages listed in `renv.lock` (DESeq2, limma, edgeR, biomaRt, metafor, clusterProfiler, msigdbr, fgsea, ComplexHeatmap, KEGGREST, data.table, ggplot2, patchwork, svglite, httr, jsonlite, UpSetR, cowplot, gridExtra).
- **Internet access** for the OSDR API, biomaRt (Ensembl), and Open Targets GraphQL API.
- **Datalake access** for LINCS L1000 signatures, Broad Drug Repurposing Hub, and PrimeKG (mounted at `/mnt/datalake/` in the Biomni environment; adapt paths in `R/lincs_reversal.R`, `R/primekg.R`, and `scripts/03_drug_screening.R` if running elsewhere).

### Data sources

| Source | Use | Access |
|---|---|---|
| NASA OSDR (GeneLab) | Human + rodent spaceflight RNA-seq | Public API |
| JAXA CFE astronaut plasma cfRNA (OSD-530) | Not used by the pipeline (cloned by script 01 only) | GitHub: `Astronaut_flavenoids_and_biomarkers`, `data/` |
| LINCS L1000 GEO signatures | Drug perturbation z-scores for tau-analog | Datalake |
| LINCS single-drug GMT | Drug up/down gene sets for fgsea cross-check | Datalake |
| Broad Drug Repurposing Hub | Drug phase / MoA / target / indication | Datalake (parquet) |
| PrimeKG | Disease-gene, drug-target, contraindication edges | Datalake (937 MB CSV) |
| Open Targets | Gene-disease associations (API) | Public GraphQL API |
| MSigDB C6 + KEGG | Oncogene union | `msigdbr` + `KEGGREST` |
| COSMIC CGC / OncoKB | Oncogene union (attempted; gated, fell back) | See caveats |

---

## Outputs

### Figures (`results/figures/`, SVG + PNG)

| Figure | Description |
|---|---|
| F1 | Dataset panel overview (study x tissue x species x factor) |
| F2 | Per-study QC PCA (DESeq2 vst, blind = TRUE) |
| F3 | Meta-signature volcano (log2FC vs -log10 p) |
| F4 | Oncogenic biomarker genes by oncogene-union source (bar chart) |
| F4b | Oncogenic biomarker genes by gene class (bar chart) |
| F5 | R vs S2 validation concordance (Spearman + sign agreement + Jaccard) |
| F6 | LINCS reversal ranking (tau distribution) |
| F7 | Tissue-stratified reversal heatmap |
| F8 | Disease enrichment (PrimeKG + Open Targets top diseases) |
| F9 | Drug context (top reversal hits with Broad phase / MoA) |
| F10 | Nutraceutical flags among top reversal hits |
| F11 | Gene-level reversal overview (bar + scatter, 3 flavonoid signatures) |
| F12 | Top 50 reversed oncogenic biomarker genes heatmap (3 signatures) |

### Tables (CSV unless noted)

The scripts write these to `results/tables/`; this repository stores them in `tables/`.
T2 is stored gzipped (`tables/T2_per_study_DE.csv.gz`, 22 MB; the plain CSV is 51.5 MB).
Run `gunzip -k` on it before running script 03, which reads the plain CSV.
T1's tissue labels follow the OSDR study records (corrected 2026-10-14); T8's `tissue`
column keeps the labels of the run that produced it (OSD-811 and OSD-993 appear there as
`mixed_cell`). `scripts/redraw_figures_from_tables.R` redraws F7 and F11 from these tables.

| Table | Rows | Description |
|---|---|---|
| T1 | 24 | Dataset panel (accession, tissue, system, factor, species; the sample-count columns are empty) |
| T2 (CSV.gz) | 410,121 | Per-study DESeq2 results |
| T3 (TSV) | 40,211 | Genome-wide meta-signature (metafor REML) |
| T4 | 1,610 | Oncogenic biomarker intersection (meta-significant AND oncogene union) |
| T4a | 5 | Oncogene source counts (MSigDB C6, KEGG, curated; COSMIC/OncoKB gated) |
| T5 | 5 | R vs S2 validation concordance metrics |
| T5b | 19,484 | R vs S2 joined gene-level comparison |
| T6 | 420 | LINCS tau-analog reversal scores (all drugs) |
| T6b | 948 | fgsea cross-check (drug up/down gene sets) |
| T7 | 50 | Top 50 signatures by tau (21 with tau < -50) |
| T8 | 4,620 | Per-study reversal scores (11 studies x 420 signatures) |
| T9 | 50 | Drug context (Broad phase, MoA, target, indication, PrimeKG) |
| T10 | 3,160 | PrimeKG disease enrichment (hypergeometric) |
| T10b | 2,898 | Combined PrimeKG + Open Targets disease ranking |
| T11 | 1,689 | Open Targets disease associations |
| T12 | 11 | Nutraceutical flags among top-50 reversal hits |
| T12b | 1 | Nutraceutical class summary |
| T12c | 37 | Full-T6 nutraceutical scan (for deferred recipe step) |
| T13 | 3,895 | Gene-level reversal: gene x signature (3 flavonoid sigs) |
| T13b | 3 | Per-signature reversal summary (counts at 3 thresholds) |
| T13c | 242 | Union of reversed genes at \|z\|>=1.5 (with per-sig z-scores) |

---

## Key results

- **Meta-signature**: 40,211 genes tested across 23 studies; 3,668 significant at padj<0.05. Intersection with an 11,241-gene oncogene union (MSigDB C6 + KEGG + curated) yields **1,610 oncogenic biomarker genes**.
- **Validation**: R rebuild vs Python S2 reference — Spearman rho = 0.60, sign agreement 76%, Jaccard top-100 = 0.19, top-500 = 0.28.
- **Drug reversal**: 17 signatures at tau = -100 (the clipping floor) and 21 below -50; 50 in the top table. They include apigenin/luteolin (food-derived flavonoids), Nutlin-3 (MDM2 inhibitor), doxorubicin (topoisomerase inhibitor), PI3K-mTOR inhibitors, MEKi+WNT, licochalcone A, 5'-Aza, SB431542, ketamine and methotrexate (tau = -99.3). One is an siRNA knockdown (SUPT4H1), not a drug.
- **Disease enrichment**: 389 significant diseases (PrimeKG padj<0.05) — top: sarcomatoid carcinoma, undifferentiated carcinoma, coronary artery disease, prostate cancer, hereditary breast/ovarian cancer, fatty liver disease. Open Targets adds neoplasm, hepatocellular carcinoma, breast carcinoma, NSCLC, glioblastoma, melanoma.
- **Nutraceuticals**: 5 unique compounds flagged among top-50 — **luteolin** (tau=-100, 3 evidence streams), **apigenin** (tau=-100), **licochalcone A** (tau=-100), licochalcone, isoginkgetin (tau=+8.7, NOT a reversal — same direction as spaceflight).
- **Gene-level reversal by flavonoids**: 242 of 1,396 assessable oncogenic biomarker genes (17.3%) directly reversed (opposite direction, |z|>=1.5) by at least one of the 3 flavonoid signatures (apigenin+luteolin GSE128097_1/2, licochalcone A GSE137934_1). 20 genes reversed by all 3 signatures. Top reversed genes: CXCL8, MMP3, CSF2, CSF3, CXCL3 (inflammatory/SASP chemokines down in spaceflight, up by flavonoids). See T13/T13b/T13c and F11/F12.

---

## Gene-level reversal by flavonoids

Script `07_gene_level_reversal.R` examines which of the 1,610 oncogenic biomarker genes are directly counter-regulated by the three flavonoid LINCS signatures at the gene level. A gene is "directly reversed" when its spaceflight meta-log2FC direction is opposite to its LINCS compound z-score direction, with |z| >= 1.5 (moderate LINCS effect; sensitivity thresholds |z|>=2 and |z|>=3 also reported).

### Key numbers

| Metric | Value |
|---|---|
| T4 oncogenic biomarkers | 1,610 |
| T4 genes assessable (non-zero z in ≥1 signature) | 1,396 (214 excluded; 1,284–1,308 per signature) |
| Reversed at \|z\|>=1.5 (union) | **242 genes (17.3%)** |
| Reversed at \|z\|>=2 (union) | 148 genes |
| Reversed at \|z\|>=3 (union) | 67 genes |
| Reversed by all 3 signatures | 20 genes |
| Reversed by 2 signatures | 87 genes |
| Reversed by 1 signature | 135 genes |

### Per-signature reversal (|z|>=1.5)

| Signature | Reversed | Concordant | Ratio |
|---|---|---|---|
| apigenin+luteolin_1 (GSE128097_1, tau=-100) | 134 | 110 | 0.55 |
| apigenin+luteolin_2 (GSE128097_2, tau=+8.7) | 136 | 127 | 0.52 |
| licochalcone_A (GSE137934_1, tau=-100) | 99 | 103 | 0.49 |

### Top reversed genes

| Gene | SF dir | SF lFC | Max \|z\| | N sigs | Class |
|---|---|---|---|---|---|
| CXCL8 | down | -1.40 | 8.49 | 2 | SASP |
| DMRT1 | up | 2.83 | 4.03 | 2 | C6_oncogenic |
| PI3 | down | -1.59 | 6.37 | 3 | C6_oncogenic |
| MMP3 | down | -1.84 | 4.92 | 3 | SASP |
| CSF3 | down | -2.28 | 3.82 | 1 | C6_oncogenic |
| CSF2 | down | -1.26 | 6.13 | 3 | SASP |
| CXCL3 | down | -1.52 | 4.88 | 3 | C6_oncogenic |
| REN | up | 1.12 | 6.42 | 1 | C6_oncogenic |
| AREG | down | -0.95 | 6.80 | 3 | C6_oncogenic |
| HAS1 | down | -1.51 | 3.98 | 2 | C6_oncogenic |

The reversed genes are dominated by inflammatory chemokines and SASP factors that spaceflight suppresses and flavonoids restore (CXCL8, MMP3, CSF2, CSF3, CXCL3), plus genes up-regulated by spaceflight that flavonoids down-regulate (DMRT1, REN). See `manuscript/manuscript.md` for the full narrative.

### Outputs

| File | Description |
|---|---|
| T13_gene_level_reversal.csv | Long: 3,895 rows (gene x signature) with z, direction, reversal flags |
| T13b_gene_level_reversal_summary.csv | Per-signature counts and ratios at 3 thresholds |
| T13c_reversed_genes_union.csv | 242 unique reversed genes with per-signature z-scores |
| F11_gene_level_reversal.svg/png | Bar chart (reversal vs concordant) + scatter (SF lFC vs compound z) |
| F12_reversed_genes_heatmap.svg/png | Top 50 reversed genes x 3 signatures heatmap (ComplexHeatmap) |

---

## Caveats and limitations

1. **COSMIC CGC and OncoKB are gated.** Both were attempted (COSMIC all URLs failed; OncoKB HTTP 401). The oncogene union fell back to MSigDB C6 (10,927 genes) + KEGG oncogenesis (931) + curated (195) = 11,241 genes. This is documented in T4a.

2. **LINCS tau-analog is a local approximation, not canonical CLUE Touchstone.** WCS values are near-zero for most drugs (the connectivity condition filters most to 0), so tau-normalization clips at +/-100. 17 signatures sit at the tau = -100 clip (21 are below -50) and cannot be ranked against each other; absolute tau values are compressed. See `R/lincs_reversal.R` for implementation.

3. **Drug-name extraction from GEO signature titles is imperfect.** Many signatures don't follow the "treatment with X" pattern, so `extract_drug_name()` falls back to GSE IDs. 7 of the top 50 matched a Broad Hub entry by name, but only 4 exactly (Nutlin-3, lapatinib, estradiol, tamoxifen): doxorubicin matched aldoxorubicin (so the Phase 3 label in T9 belongs to aldoxorubicin), and a stapled-peptide ER inhibitor matched iRGD-peptide twice (spurious). The full signature string is preserved in all tables for manual review.

4. **PrimeKG disease enrichment universe** is a fixed 20,000 genes (`UNIVERSE_SIZE` in `scripts/04_enrichment.R`), approximating the protein-coding genome, not the set of genes tested in the meta-analysis. The p-values depend on this choice.

5. **F2 QC PCA is per-study, not cross-study.** Studies use different platforms, gene spaces, and species, so cross-study PCA would confound biology with batch. Per-study PCA correctly shows whether treated vs control separates within each study.

6. **Nutraceutical coverage is skewed toward flavonoids.** Only flavonoids (apigenin, luteolin, licochalcone A, isoginkgetin) surfaced among top-50 reversal hits. No vitamins, carotenoids, or omega-3s appear in the LINCS GEO signature set — a data-coverage limitation (LINCS GEO signatures skew toward oncology drugs), not a method failure.

7. **Vegan recipe optimization is deferred.** This pipeline flags nutraceutical candidates (T12, T12c) as preparation; the recipe-matching step is out of scope here.

8. **biomaRt flakiness.** Ensembl redirects to a status page during outages. `R/orthologs.R` includes mirror retry logic (www.ensembl.org, useast, asia). `getLDS` frequently returns HTTP 500 but `getBM` succeeds — fallback uses MGI symbols uppercased as human HGNC.

---

## Reproducibility

- `renv.lock` pins all 26 R package versions.
- `run_all.R` provides one-command reproduction with `--from` / `--only` flags for resumability.
- All figures are saved as both SVG (editable, preferred) and PNG.
- Random seeds are set where stochasticity applies (DESeq2, metafor, PCA are deterministic; no Monte Carlo steps).

---

## License

MIT — see [LICENSE](../LICENSE).

## Citation

See [CITATION.cff](CITATION.cff). If you use this software, please cite:

> Barker, R. (2026). astronaut-opposite-forcing: An R pipeline for spaceflight oncogenic biomarker discovery and transcriptomic reversal (opposite-forcing) drug screening. https://github.com/dr-richard-barker/Astronaut_flavenoids_and_biomarkers/tree/main/astronaut-opposite-forcing

## Related

- [`astronaut-oncogene-biomarkers`](https://github.com/dr-richard-barker/astronaut-oncogene-biomarkers) — the Python discovery repo whose S2 meta-signature is used here as validation reference.
