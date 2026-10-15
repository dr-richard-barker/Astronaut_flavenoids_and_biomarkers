#' Plot definitions for F7 (tissue-stratified reversal) and F11 (gene-level reversal).
#'
#' Shared by scripts/03_drug_screening.R, scripts/07_gene_level_reversal.R and
#' scripts/redraw_figures_from_tables.R, so the pipeline and the redraw from the
#' committed tables draw the same figure.
#'
#' Base R + ggplot2 + patchwork only (no data.table), so it can be sourced anywhere.

#' Short, unique label for a GEO signature: truncated title + its GSE id.
#' @param sig character vector of signature names ("<title> GSE123_1")
sig_label <- function(sig, width = 42) {
  gse <- ifelse(grepl("GSE[0-9]+_[0-9]+$", sig),
                sub("^.*(GSE[0-9]+_[0-9]+)$", "\\1", sig), "")
  title <- trimws(sub("GSE[0-9]+_[0-9]+$", "", sig))
  short <- ifelse(nchar(title) > width, paste0(substr(title, 1, width - 3), "..."), title)
  ifelse(gse == "", short, paste0(short, " [", gse, "]"))
}

#' F7: tau of the top-N signatures (most negative overall tau in T6) in each study of T8.
#' @param reversal data.frame(signature, tau): the overall screen (T6)
#' @param tissue_rev data.frame(study, tissue, signature, tau): per-study scores (T8)
#' @param top_n number of signatures to show
plot_f7 <- function(reversal, tissue_rev, top_n = 20, base_family = "Liberation Sans") {
  # Order explicitly by tau: the table passed in may not be sorted (in script 03 the
  # fgsea merge re-sorts it by name, which is how F7 once showed the alphabetically
  # first signatures instead of the top hits).
  reversal <- reversal[order(reversal$tau, reversal$signature), ]
  top <- head(reversal$signature, top_n)
  tr <- tissue_rev[tissue_rev$signature %in% top, ]
  missing <- setdiff(top, tr$signature)
  if (length(missing) > 0) stop("F7: top signatures absent from the per-study table: ",
                                paste(missing, collapse = "; "))

  tr$row <- factor(sig_label(tr$signature), levels = rev(sig_label(top)))
  studies <- unique(tr[order(tr$tissue, tr$study), c("study", "tissue")])
  # one word per line so neighbouring column labels cannot overlap
  col_lab <- function(study, tissue) paste0(study, "\n", gsub("_", "\n", tissue))
  tr$col <- factor(col_lab(tr$study, tr$tissue),
                   levels = col_lab(studies$study, studies$tissue))
  n_floor <- sum(reversal$tau[seq_len(min(top_n, nrow(reversal)))] <= -100)

  ggplot2::ggplot(tr, ggplot2::aes(x = col, y = row, fill = tau)) +
    ggplot2::geom_tile(color = "white") +
    ggplot2::geom_text(ggplot2::aes(label = round(tau)), size = 2.2,
                       family = base_family, color = "grey15") +
    ggplot2::scale_fill_gradient2(low = "#0279EE", mid = "grey95", high = "#c0392b",
                                  midpoint = 0, limits = c(-100, 100)) +
    ggplot2::labs(
      title = sprintf("Tissue-stratified reversal of the top %d signatures (LINCS tau-analog)", top_n),
      subtitle = sprintf(paste0("Rows: the %d most negative overall tau (%d tie at the -100 clip). ",
                                "Columns: the %d studies with per-study scores. Negative = reversal."),
                         top_n, n_floor, nrow(studies)),
      caption = "Data: T6_lincs_reversal_scores.csv (rows), T8_tissue_stratified_reversal.csv (cells); tissue labels from T1 / OSDR",
      x = "study (tissue)", y = NULL, fill = "tau") +
    ggplot2::theme_minimal(base_family = base_family) +
    ggplot2::theme(plot.title = ggplot2::element_text(size = 11, face = "bold"),
                   plot.subtitle = ggplot2::element_text(size = 8),
                   plot.caption = ggplot2::element_text(size = 7, color = "grey40"),
                   axis.text.y = ggplot2::element_text(size = 7),
                   axis.text.x = ggplot2::element_text(size = 7),
                   panel.grid = ggplot2::element_blank())
}

#' Reversed / concordant counts per signature at |z| >= 1.5, 2, 3 (the T13b definitions).
f11_counts <- function(t13) {
  thr <- c("|z|>=1.5" = 1.5, "|z|>=2" = 2, "|z|>=3" = 3)
  rev_flag <- as.logical(t13$reversed)
  do.call(rbind, lapply(names(thr), function(th) {
    strong <- abs(t13$compound_z) >= thr[[th]]
    n_rev <- tapply(rev_flag & strong, t13$compound_label, sum)
    n_con <- tapply(!rev_flag & strong, t13$compound_label, sum)
    rbind(data.frame(compound_label = names(n_rev), threshold = th,
                     count = as.integer(n_rev), type = "reversed"),
          data.frame(compound_label = names(n_con), threshold = th,
                     count = as.integer(n_con), type = "concordant"))
  }))
}

#' F11: (A) reversed vs concordant counts per flavonoid signature; (B) apigenin+luteolin_1 scatter.
#' @param t13 data.frame in the T13_gene_level_reversal.csv layout
plot_f11 <- function(t13, base_family = "Liberation Sans") {
  blue <- "#0279EE"; orange <- "#FF9400"; grey <- "#B0B0B0"
  sig_levels <- c("apigenin+luteolin_1", "apigenin+luteolin_2", "licochalcone_A")

  bar <- f11_counts(t13)
  bar$threshold <- factor(bar$threshold, levels = c("|z|>=1.5", "|z|>=2", "|z|>=3"))
  bar$compound_label <- factor(bar$compound_label, levels = sig_levels)

  pA <- ggplot2::ggplot(bar, ggplot2::aes(x = threshold, y = count, fill = type)) +
    ggplot2::geom_col(position = ggplot2::position_dodge(width = 0.7), width = 0.6) +
    ggplot2::geom_text(ggplot2::aes(label = count), position = ggplot2::position_dodge(width = 0.7),
                       vjust = -0.3, size = 3, family = base_family) +
    ggplot2::facet_wrap(~ compound_label, ncol = 3) +
    ggplot2::scale_fill_manual(values = c("reversed" = blue, "concordant" = orange), name = "Direction") +
    ggplot2::scale_y_continuous(expand = ggplot2::expansion(mult = c(0, 0.12))) +
    ggplot2::labs(title = "Gene-level reversal of oncogenic biomarkers by flavonoids",
                  subtitle = "Counts per signature. Reversed = spaceflight direction opposite to compound z-score",
                  x = "LINCS |z| threshold", y = "Number of T4 genes") +
    ggplot2::theme_minimal(base_family = base_family) +
    ggplot2::theme(plot.title = ggplot2::element_text(face = "bold"),
                   strip.text = ggplot2::element_text(face = "bold", size = 10),
                   strip.background = ggplot2::element_rect(fill = "grey92", color = NA),
                   panel.grid.minor = ggplot2::element_blank(),
                   legend.position = "bottom")

  sc <- t13[t13$compound_label == "apigenin+luteolin_1", ]
  rz <- as.logical(sc[["reversed_z1.5"]]); cz <- as.logical(sc[["concordant_z1.5"]])
  sc$status <- ifelse(rz, "Reversed (|z|>=1.5)", ifelse(cz, "Concordant (|z|>=1.5)", "Below threshold"))
  xr <- range(sc$mean_lfc); yr <- range(sc$compound_z)

  pB <- ggplot2::ggplot(sc, ggplot2::aes(x = mean_lfc, y = compound_z, color = status)) +
    ggplot2::geom_point(alpha = 0.6, size = 1.5) +
    ggplot2::geom_hline(yintercept = 0, color = "grey50", linewidth = 0.3) +
    ggplot2::geom_vline(xintercept = 0, color = "grey50", linewidth = 0.3) +
    ggplot2::geom_hline(yintercept = c(-1.5, 1.5), linetype = "dashed", color = "grey70", linewidth = 0.3) +
    ggplot2::scale_color_manual(values = c("Reversed (|z|>=1.5)" = blue,
                                           "Concordant (|z|>=1.5)" = orange,
                                           "Below threshold" = grey), name = "Status") +
    # Quadrant labels anchored inside the data range so neither is clipped.
    ggplot2::annotate("text", x = xr[1], y = yr[2], label = "Reversed quadrant\n(SF down, compound up)",
                      hjust = 0, vjust = 1, size = 3, color = blue, fontface = "bold", family = base_family) +
    ggplot2::annotate("text", x = xr[2], y = yr[1], label = "Reversed quadrant\n(SF up, compound down)",
                      hjust = 1, vjust = 0, size = 3, color = blue, fontface = "bold", family = base_family) +
    ggplot2::labs(title = "Apigenin + Luteolin (GSE128097_1)",
                  subtitle = sprintf("%d reversed, %d concordant at |z|>=1.5", sum(rz), sum(cz)),
                  caption = "Data: T13_gene_level_reversal.csv (counts as in T13b)",
                  x = "Spaceflight mean log2FC (T4 oncogenic biomarkers)",
                  y = "LINCS compound z-score") +
    ggplot2::theme_minimal(base_family = base_family) +
    ggplot2::theme(plot.title = ggplot2::element_text(face = "bold"),
                   plot.caption = ggplot2::element_text(size = 7, color = "grey40"),
                   panel.grid.minor = ggplot2::element_blank(),
                   legend.position = "bottom")

  patchwork::wrap_plots(pA, pB, ncol = 1, heights = c(1, 1.2))
}

#' Save a plot as SVG + PNG. Uses svglite when installed (as the pipeline does),
#' otherwise the Cairo SVG device.
save_svg_png <- function(plot, base_path, width, height, dpi = 150) {
  svg_path <- paste0(base_path, ".svg")
  if (requireNamespace("svglite", quietly = TRUE)) {
    svglite::svglite(svg_path, width = width, height = height)
  } else {
    grDevices::svg(svg_path, width = width, height = height)
  }
  print(plot)
  grDevices::dev.off()
  ggplot2::ggsave(paste0(base_path, ".png"), plot, width = width, height = height,
                  dpi = dpi, bg = "white")
  invisible(c(svg_path, paste0(base_path, ".png")))
}
