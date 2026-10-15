# Astronaut Health Search — spaceflight oncogenic biomarkers and their reversal by food-derived flavonoids

**A from-scratch R pipeline for "opposite-forcing" drug discovery against spaceflight oncogenic biomarker signatures, plus separate supporting iDEP analyses of JAXA astronaut plasma cell-free RNA and human-cell RNA-seq data.**

🌐 **Live site:** [https://dr-richard-barker.github.io/Astronaut_flavenoids_and_biomarkers/](https://dr-richard-barker.github.io/Astronaut_flavenoids_and_biomarkers/)

> Independent research. Not affiliated with or endorsed by NASA or JAXA.

---

![Reversing Spaceflight Genetic Risk Research](Reversing_Spaceflight_Genetic_Risk_Research.png)

## Overview

Microgravity and ionising radiation are independently linked to hallmarks of
early oncogenesis. This repository asks whether a reproducible **oncogenic
biomarker signature** emerges across human and rodent spaceflight transcriptomes,
and whether existing drug or nutraceutical perturbation signatures can **reverse**
it ("opposite forcing").

The main analysis (`astronaut-opposite-forcing/`) is a from-scratch R pipeline
that:

1. Re-discovers a spaceflight oncogenic biomarker signature across **23 NASA
   OSDR RNA-seq studies** (10 human, 13 rodent) using strict DE thresholds
   (padj < 0.05, |log2FC| > 1) and a random-effects meta-analysis (`metafor` REML).
2. Screens **420 LINCS L1000 drug perturbation signatures** for transcriptomic
   reversal via a tau-analog connectivity score.
3. Annotates top reversal hits with target/indication context (Broad Drug
   Repurposing Hub, PrimeKG).
4. Maps the signature to disease phenotypes (PrimeKG, Open Targets).
5. Flags nutraceutical candidates among the top reversal compounds.

## Key results

| Finding | Value |
|--------|-------|
| Meta-analysis genes scored | 40,211 (3,668 significant) |
| Oncogenic biomarker genes (∩ 11,241-gene oncogene union) | **1,610** |
| Validation vs. independent Python meta-signature (S2) | Spearman ρ = 0.60, 76% sign agreement |
| Signatures with maximal reversal (tau = −100) | 17 (21 with tau < −50) |
| Lead nutraceutical hits | **apigenin, luteolin, licochalcone A** (food-derived flavonoids) |
| Biomarker genes directly reversed by ≥1 flavonoid | 242 / 1,396 assessable (17.3%); 20 reversed by all three |
| Disease enrichment | sarcomatoid carcinoma, coronary artery disease, prostate cancer, hereditary breast/ovarian cancer, fatty liver disease |

Full methods, figures, and the complete results narrative are available in:
- **Manuscript (PDF):** [`docs/Astronaut_flavenoids_and_biomarkers_manuscript.pdf`](docs/Astronaut_flavenoids_and_biomarkers_manuscript.pdf)
- **Manuscript (Word DOCX):** [`docs/Astronaut_flavenoids_and_biomarkers_manuscript.docx`](docs/Astronaut_flavenoids_and_biomarkers_manuscript.docx)
- **Manuscript (Markdown):** [`astronaut-opposite-forcing/manuscript/manuscript.md`](astronaut-opposite-forcing/manuscript/manuscript.md)
- **LaTeX source (npj Microgravity style):** [`astronaut-opposite-forcing/manuscript/latex/`](astronaut-opposite-forcing/manuscript/latex/)
- **Supplementary tables (T3–T13c):** [`astronaut-opposite-forcing/tables/`](astronaut-opposite-forcing/tables/)
- **Publication figures (F1–F12):** [`astronaut-opposite-forcing/figures/`](astronaut-opposite-forcing/figures/)

## Repository structure

```
.
├── astronaut-opposite-forcing/   # MAIN analysis
│   ├── manuscript/               # Full manuscript (Markdown, LaTeX, PDF, DOCX)
│   │   ├── manuscript.md
│   │   ├── manuscript.pdf
│   │   ├── manuscript.docx
│   │   └── latex/                # Springer Nature npj Microgravity template
│   ├── figures/                  # Publication figures F1–F12 + F4b (PNG & SVG)
│   ├── scripts/                  # R execution pipeline (01_OSD_query to 07_gene_level_reversal)
│   ├── R/                        # Reusable R modules
│   └── tables/                   # Supplementary tables T3–T13c
│       ├── T3_meta_signature.tsv
│       ├── T4_oncogene_intersection.csv       # the 1,610 biomarker genes
│       ├── T5_validation_concordance.csv      # Concordance with S2
│       ├── T6_lincs_reversal_scores.csv       # 420 drug perturbation scores
│       ├── T7_top_opposite_forcing.csv        # top 50 signatures by tau (21 below −50)
│       ├── T8_tissue_stratified_reversal.csv  # per-study scores, 11 studies
│       ├── T9_drug_context.csv                # Broad Hub / PrimeKG annotation
│       ├── T10b_disease_enrichment_combined.csv
│       ├── T11_disease_enrichment_opentargets.csv
│       ├── T12_nutraceutical_flags.csv        # Top-50 nutraceutical candidates
│       ├── T12c_nutraceutical_full_scan.csv   # 37 nutraceutical signatures
│       ├── T13_gene_level_reversal.csv        # 3,895 gene x signature comparisons
│       ├── T13b_gene_level_reversal_summary.csv
│       └── T13c_reversed_genes_union.csv      # 242 unique reversed genes
├── data/                          # JAXA data (not read by the R pipeline)
│   ├── JAXA6_FL_vs_Pre_diff_expression_all_comparisons.csv
│   ├── JAXA5_venn_for_metaanalysis.csv
│   ├── JAXA_Matrix_TGB_050_..._targets_.csv
│   ├── JAXA6_TGB_050_..._SEM_4iDEP.csv.zip
│   └── JAXA_RPM_human_cells_RNAseq/
├── docs/                          # Live GitHub Pages site & deployed manuscript
│   ├── index.html
│   ├── Astronaut_flavenoids_and_biomarkers_manuscript.pdf
│   ├── Astronaut_flavenoids_and_biomarkers_manuscript.docx
│   └── assets/
│       ├── style.css
│       ├── figures/               # High-res publication & JAXA figures
│       └── ...
├── figures/                       # iDEP / KEGG figures (JAXA6 analysis)
│   ├── iDEP_DRB_JAXA6_V1.svg
│   ├── KEGG_fl_vs_GC.svg
│   └── Jaxa6_iDEP_figures_August/
├── execution_trace/PLAN.md        # Gene-level flavonoid-reversal analysis plan
├── LICENSE                        # MIT
└── README.md
```

## Data sources

- **NASA Open Science Data Repository (OSDR / GeneLab):** https://osdr.nasa.gov
  (cite the individual OSD accessions listed in the manuscript).
- **LINCS L1000** drug perturbation signatures (via GEO).
- **JAXA** — `data/` holds astronaut plasma cell-free RNA from the JAXA Cell-Free
  Epigenome study ([OSD-530](https://osdr.nasa.gov/bio/repo/data/studies/OSD-530);
  six astronauts, 64 samples before, during and after flight; files
  `JAXA6_*`, `JAXA_Matrix_TGB_050_*`) and human-cell RNA-seq whose columns are
  labelled 1G and suG (`JAXA_RPM_human_cells_RNAseq/`). The R pipeline does not read
  them. The iDEP and KEGG figures in `figures/` come from separate iDEP analyses; the
  source dataset of `KEGG_fl_vs_GC.svg` is not recorded (TODO).
- Annotation: MSigDB C6, KEGG, Broad Drug Repurposing Hub, PrimeKG, Open Targets.

## Reproduction

The opposite-forcing pipeline is implemented in R; see the Methods section of
`astronaut-opposite-forcing/manuscript/manuscript.md` for package versions,
thresholds, and the connectivity-score formulation. The JAXA supporting
analysis was produced with [iDEP](http://bioinformatics.sdstate.edu/idep/).

## Code availability

The R pipeline — meta-analysis, LINCS L1000 opposite-forcing screen, and
gene-level flavonoid reversal — is in
[`astronaut-opposite-forcing/scripts/`](astronaut-opposite-forcing/scripts/),
with full methods in
[`astronaut-opposite-forcing/manuscript/manuscript.md`](astronaut-opposite-forcing/manuscript/manuscript.md).
The independent Python cross-study meta-signature (S2) used for validation lives
in the companion repository
[**astronaut-oncogene-biomarkers**](https://github.com/dr-richard-barker/astronaut-oncogene-biomarkers).

## Requirements

> **TODO:** pin exact package versions (add an `renv.lock` or the output of
> `sessionInfo()`).

- **R** (≥ 4.x) — the core opposite-forcing pipeline.
- **Key R packages** named in the Methods: `DESeq2` (per-study differential
  expression), `metafor` (REML random-effects meta-analysis), `biomaRt`
  (rodent → human ortholog mapping).
- **Reference resources:** LINCS L1000 drug perturbation signatures, MSigDB C6,
  KEGG, Broad Drug Repurposing Hub, PrimeKG, Open Targets.
- **Reproducibility:** add a pinned environment file so reviewers can restore the
  exact package set.

## Related work

- [**astronaut-oncogene-biomarkers**](https://github.com/dr-richard-barker/astronaut-oncogene-biomarkers)
  — the companion Python cross-study meta-signature (S2) used here for
  independent validation.

## License

**MIT** — see [`LICENSE`](LICENSE). OSDR/LINCS/JAXA source data remain subject to
their own terms; cite the original accessions.

## Citation

> **TODO:** add co-authors (ORCID), affiliation, and DOI once available.

Barker, R. et al. (2026). *Spaceflight oncogenic biomarkers and their
transcriptomic reversal by food-derived flavonoids: an R pipeline for
opposite-forcing drug discovery.* Manuscript in preparation (targeted at *npj
Microgravity*). Correspondence: admin@cosecloud.com
