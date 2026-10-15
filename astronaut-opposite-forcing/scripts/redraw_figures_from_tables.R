#!/usr/bin/env Rscript
# ==============================================================================
# redraw_figures_from_tables.R
#
# Redraws F7 and F11 from the committed tables, without the datalake inputs that
# scripts 03 and 07 need. Uses the same plot definitions (R/figures_reversal.R).
#
#   F7  <- tables/T6_lincs_reversal_scores.csv, tables/T8_tissue_stratified_reversal.csv,
#          tables/T1_dataset_panel.csv (tissue labels; T8 carries the labels of its run)
#   F11 <- tables/T13_gene_level_reversal.csv, checked against T13b
#
# Run from astronaut-opposite-forcing/:   Rscript scripts/redraw_figures_from_tables.R
# Writes figures/F7_*.svg/png and figures/F11_*.svg/png. The copies in
# docs/assets/figures/ and manuscript/latex/figures/ are refreshed by hand.
# ==============================================================================

source("R/figures_reversal.R")

tab_dir <- "tables"
fig_dir <- "figures"

# Liberation Sans as in the pipeline when installed, else Arial, else the default.
fam <- "sans"
if (requireNamespace("systemfonts", quietly = TRUE)) {
  have <- unique(systemfonts::system_fonts()$family)
  fam <- c(intersect(c("Liberation Sans", "Arial"), have), "sans")[1]
}
cat(sprintf("[redraw] font family: %s\n", fam))

# ---- F7 ----------------------------------------------------------------------
t6 <- read.csv(file.path(tab_dir, "T6_lincs_reversal_scores.csv"), stringsAsFactors = FALSE)
t8 <- read.csv(file.path(tab_dir, "T8_tissue_stratified_reversal.csv"), stringsAsFactors = FALSE)
t1 <- read.csv(file.path(tab_dir, "T1_dataset_panel.csv"), stringsAsFactors = FALSE)
stopifnot(all(t8$study %in% t1$accession))
t8$tissue <- t1$tissue[match(t8$study, t1$accession)]

p7 <- plot_f7(t6, t8, top_n = 20, base_family = fam)
save_svg_png(p7, file.path(fig_dir, "F7_tissue_stratified_reversal"), width = 10, height = 7)
cat(sprintf("[redraw] F7: %d studies x 20 signatures\n", length(unique(t8$study))))

# ---- F11 ---------------------------------------------------------------------
t13  <- read.csv(file.path(tab_dir, "T13_gene_level_reversal.csv"), stringsAsFactors = FALSE,
                 check.names = FALSE)
t13b <- read.csv(file.path(tab_dir, "T13b_gene_level_reversal_summary.csv"), stringsAsFactors = FALSE,
                 check.names = FALSE)

# The bars must reproduce T13b exactly, signature by signature.
cnt <- f11_counts(t13)
col_of <- c("reversed|z|>=1.5" = "n_reversed_z1.5", "reversed|z|>=2" = "n_reversed_z2",
            "reversed|z|>=3" = "n_reversed_z3", "concordant|z|>=1.5" = "n_concordant_z1.5",
            "concordant|z|>=2" = "n_concordant_z2", "concordant|z|>=3" = "n_concordant_z3")
expected <- mapply(function(lab, key) t13b[t13b$compound_label == lab, col_of[[key]]],
                   cnt$compound_label, paste0(cnt$type, cnt$threshold))
if (!identical(as.integer(expected), cnt$count)) {
  print(cbind(cnt, expected = expected))
  stop("F11 counts do not match T13b")
}
cat(sprintf("[redraw] F11 counts match T13b (%d cells)\n", nrow(cnt)))

p11 <- plot_f11(t13, base_family = fam)
save_svg_png(p11, file.path(fig_dir, "F11_gene_level_reversal"), width = 12, height = 10)
cat("[redraw] wrote F7 and F11 (svg + png) to figures/\n")
