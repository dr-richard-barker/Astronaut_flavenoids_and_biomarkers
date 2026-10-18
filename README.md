# Astronaut Health Search: JAXA astronaut cell-free RNA data

> **Withdrawn analysis.** The "opposite-forcing" analysis that used to be in this repository (spaceflight oncogenic
> biomarkers and their reversal by food-derived flavonoids) was withdrawn on 18 October 2026. See
> [Withdrawn analysis](#withdrawn-analysis) below.

🌐 **Live site:** [https://dr-richard-barker.github.io/Astronaut_flavenoids_and_biomarkers/](https://dr-richard-barker.github.io/Astronaut_flavenoids_and_biomarkers/)

> Independent research. Not affiliated with or endorsed by NASA or JAXA.

---

## What is here

```
.
├── data/
│   ├── JAXA6_FL_vs_Pre_diff_expression_all_comparisons.csv
│   ├── JAXA6_TGB_050_..._SEM_4iDEP.csv.zip
│   ├── JAXA_Matrix_TGB_050_..._targets_.csv
│   ├── JAXA5_venn_for_metaanalysis.csv
│   └── JAXA_RPM_human_cells_RNAseq/
├── figures/          # iDEP and KEGG figures
├── docs/             # GitHub Pages site
├── LICENSE           # MIT
└── README.md
```

- **Astronaut plasma cell-free RNA:** `JAXA6_*` and `JAXA_Matrix_TGB_050_*` come from the JAXA Cell-Free Epigenome
  study ([OSD-530](https://osdr.nasa.gov/bio/repo/data/studies/OSD-530)). Six astronauts gave 64 samples before,
  during and after flight.
- **`JAXA5_venn_for_metaanalysis.csv`:** up- and down-regulated gene lists for flight vs pre-mission, flight vs
  post-mission, and pre- vs post-mission. The analysis that produced it is not recorded (TODO).
- **`JAXA_RPM_human_cells_RNAseq/`:** human-cell RNA-seq with columns labelled 1G and suG, for IMR90 iPSC-derived
  cells and TK6 cells. The same tables also hold pre-, in- and post-flight normalized means.
- **`figures/`:** figures from separate [iDEP](http://bioinformatics.sdstate.edu/idep/) analyses. The source dataset
  of `KEGG_fl_vs_GC.svg` is not recorded (TODO).

There is no analysis code in this repository; the figures were made in iDEP.

## Withdrawn analysis

Until 18 October 2026 this repository held an R pipeline, `astronaut-opposite-forcing/`. It derived a spaceflight
oncogenic biomarker signature from 23 NASA OSDR RNA-seq studies, screened LINCS L1000 perturbation signatures for
ones that reverse it, and highlighted food-derived flavonoids. A manuscript describing it was in preparation.

The manuscript, README and site described the cross-study meta-analysis as a random-effects model (`metafor`,
REML). It was not one. 33,365 genes were measured in two or more studies. For every one of them, the published
meta-signature (table T3) matches the Stouffer combined-z fallback in the pipeline's error handler exactly, and
none matches a REML fit. The REML call failed for every gene, and the error handler substituted Stouffer's method
without logging it. Stouffer's method ignores the heterogeneity between studies, species and tissues that the
random-effects model was chosen to handle.

Every later result depends on that signature: the 1,610 biomarker genes, the LINCS reversal scores, and the
flavonoid findings. Re-running the pipeline properly would mean starting again from the source data, so the
analysis was withdrawn rather than corrected. The last version is in the git history at commit `1f16c8f`. It is
kept for the record and should not be cited or reused.

## License

**MIT**: see [`LICENSE`](LICENSE). The JAXA and OSDR source data remain subject to their own terms; cite
OSD-530 for the astronaut cell-free RNA.
