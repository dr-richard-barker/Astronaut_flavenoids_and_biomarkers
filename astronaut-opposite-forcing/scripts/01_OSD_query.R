#' Script 01 — Data acquisition: human + rodent OSDR RNA-seq (+ clone of this repository).
#'
#' Pulls processed count matrices + DGE tables (no FASTQ/BAM) for:
#'   - Human panel (11 studies, reused from the discovery repo's curated panel)
#'   - Rodent panel (13 Mus musculus studies: spaceflight + hindlimb suspension + radiation)
#'   - A clone of GitHub: Astronaut_flavenoids_and_biomarkers. Its data/ folder holds the JAXA
#'     Cell-Free Epigenome astronaut plasma cell-free RNA data (OSD-530), which no later
#'     script reads.
#'
#' Tissue labels follow the OSDR study records (Material Type / cell type), checked 2026-10-14.
#'
#' Idempotent / resume-safe: skips already-downloaded files.
#'
#' Usage:
#'   Rscript scripts/01_OSD_query.R            # fetch all
#'   Rscript scripts/01_OSD_query.R --list     # dry-run
#'   Rscript scripts/01_OSD_query.R --skip-github

source("R/osdr_client.R")

# ---- curated panels ----
HUMAN_PANEL <- list(
  `OSD-258` = list(tissue="cardiomyocyte",      system="stem_cell",        factor="spaceflight",           species="human"),
  `OSD-431` = list(tissue="endothelial",        system="vascular_model",   factor="microgravity_radiation",species="human"),
  `OSD-635` = list(tissue="vascular_smc",       system="vascular_model",   factor="spaceflight",           species="human"),
  `OSD-684` = list(tissue="skeletal_muscle",    system="tissue_chip",      factor="microgravity",          species="human"),
  `OSD-811` = list(tissue="cardiac_sphere",     system="microgravity_model",factor="microgravity",         species="human", note="hiPSC-derived cardiac spheres, ISS uG vs 1G centrifuge"),
  `OSD-863` = list(tissue="neural_organoid",    system="neural_model",     factor="spaceflight",           species="human"),
  `OSD-867` = list(tissue="msc",                system="stem_cell",        factor="spaceflight",           species="human"),
  `OSD-903` = list(tissue="whole_blood",        system="astronaut_in_vivo",factor="spaceflight",           species="human"),
  `OSD-937` = list(tissue="skeletal_muscle",    system="cell_model",       factor="microgravity",          species="human"),
  `OSD-940` = list(tissue="colorectal_organoid",system="cancer_model",     factor="simulated_microgravity",species="human"),
  `OSD-993` = list(tissue="dermal_fibroblast",  system="radiation_model",  factor="space_radiation",       species="human", note="Primary dermal fibroblasts, ion/gamma irradiation")
)

# Rodent panel: 13 Mus musculus studies spanning spaceflight, hindlimb suspension (microgravity analog),
# and ionizing radiation, across diverse tissues. Selected from 141 relevant OSDR Mus musculus RNA-seq
# studies by requiring a clean perturbation contrast and downloadable processed count matrices.
RODENT_PANEL <- list(
  `OSD-164` = list(tissue="liver_spleen",     system="rodent_in_vivo",    factor="spaceflight",          species="mouse", note="Spaceflight immunoglobulin repertoire; 6 liver + 6 spleen samples pooled in one contrast"),
  `OSD-289` = list(tissue="thymus",           system="rodent_in_vivo",    factor="spaceflight",          species="mouse", note="Spaceflight thymus gene expression"),
  `OSD-242` = list(tissue="liver",            system="rodent_in_vivo",    factor="spaceflight",          species="mouse", note="ISS 33-day mouse liver transcriptomics"),
  `OSD-240` = list(tissue="skin",             system="rodent_in_vivo",    factor="spaceflight",          species="mouse", note="RR-5 dorsal skin spaceflight"),
  `OSD-100` = list(tissue="eye",              system="rodent_in_vivo",    factor="spaceflight",          species="mouse", note="RR-1 NASA validation flight, mouse eye"),
  `OSD-173` = list(tissue="liver",            system="rodent_in_vivo",    factor="spaceflight",          species="mouse", note="STS-135 mouse liver RNA-seq"),
  `OSD-599` = list(tissue="heart",            system="rodent_in_vivo",    factor="spaceflight",          species="mouse", note="Mouse heart 30 days ISS"),
  `OSD-295` = list(tissue="skeletal_muscle",  system="ground_analog",     factor="hindlimb_suspension",  species="mouse", note="Soleus hindlimb unloading (microgravity analog)"),
  `OSD-467` = list(tissue="bone",             system="ground_analog",     factor="hindlimb_suspension",  species="mouse", note="Cortical bone hindlimb unloading"),
  `OSD-294` = list(tissue="liver",            system="radiation_model",   factor="ionizing_radiation",   species="mouse", note="Liver ionizing radiation RNA-seq"),
  `OSD-374` = list(tissue="hippocampus",      system="radiation_model",   factor="ionizing_radiation",   species="mouse", note="Proton irradiation, hippocampus (RNA-seq + methylation)"),
  `OSD-566` = list(tissue="adrenal_gland",    system="radiation_model",   factor="ionizing_radiation",   species="mouse", note="Sexual dimorphism, adrenal gland, mixed-field radiation"),
  `OSD-322` = list(tissue="liver",            system="radiation_model",   factor="ionizing_radiation",   species="mouse", note="56Fe/16O/28Si irradiation time course, liver (hepatocellular carcinoma model)")
)

GITHUB_REPO <- "https://github.com/dr-richard-barker/Astronaut_flavenoids_and_biomarkers.git"

main <- function(args = commandArgs(trailingOnly = TRUE)) {
  dry <- "--list" %in% args
  skip_github <- "--skip-github" %in% args

  root <- getwd()
  raw_dir <- file.path(root, "data", "raw")
  ext_dir <- file.path(root, "data", "external")
  dir.create(raw_dir, showWarnings = FALSE, recursive = TRUE)
  dir.create(ext_dir, showWarnings = FALSE, recursive = TRUE)

  session <- NULL  # use default httr requests (osdr_client handles user-agent)

  # ---- JAXA6 from GitHub ----
  jaxa_dest <- file.path(ext_dir, "Astronaut_flavenoids_and_biomarkers")
  if (!skip_github) {
    if (!dir.exists(file.path(jaxa_dest, ".git"))) {
      cat(sprintf("[github] cloning %s\n", GITHUB_REPO))
      system2("git", c("clone", "--depth", "1", GITHUB_REPO, jaxa_dest))
    } else {
      cat(sprintf("[github] already present: %s\n", jaxa_dest))
    }
  } else if (dry) {
    cat(sprintf("[github] would clone %s\n", GITHUB_REPO))
  }

  # ---- fetch OSDR panels ----
  fetch_panel <- function(panel, label) {
    cat(sprintf("\n=== %s panel (%d studies) ===\n", label, length(panel)))
    rows <- list()
    for (acc in names(panel)) {
      meta <- panel[[acc]]
      dest_dir <- file.path(raw_dir, acc)
      tryCatch({
        files <- list_files(acc, session = session)
        picked <- select_processed(files)
      }, error = function(e) {
        cat(sprintf("[osdr] %s: FAILED to list files (%s)\n", acc, conditionMessage(e)))
        picked <- data.frame()
      })
      tag <- sprintf("%s [%s/%s/%s]", acc, meta$tissue, meta$factor, meta$species)
      if (nrow(picked) == 0) {
        cat(sprintf("[osdr] %s: no processed products matched\n", tag))
        next
      }
      cat(sprintf("[osdr] %s: %d processed file(s)\n", tag, nrow(picked)))
      n_ctrl <- n_trt <- NA  # filled in during harmonization
      rows[[length(rows)+1]] <- data.frame(
        accession = acc, tissue = meta$tissue, system = meta$system,
        factor = meta$factor, species = meta$species,
        n_control = n_ctrl, n_treated = n_trt,
        note = meta$note %||% "", stringsAsFactors = FALSE
      )
      if (!dry) {
        for (i in seq_len(nrow(picked))) {
          f <- as.list(picked[i, ])
          mb <- round((as.numeric(f$file_size) %||% 0) / 1e6, 2)
          path <- tryCatch(download(f, dest_dir, session = session),
                           error = function(e) { cat(sprintf("    download failed: %s\n", conditionMessage(e))); NA })
          if (!is.na(path)) cat(sprintf("    + %s (%.2f MB)\n", basename(path), mb))
        }
      } else {
        for (i in seq_len(nrow(picked))) {
          f <- as.list(picked[i, ])
          mb <- round((as.numeric(f$file_size) %||% 0) / 1e6, 2)
          cat(sprintf("    - %s (%.2f MB)\n", f$file_name, mb))
        }
      }
    }
    do.call(rbind, rows)
  }

  human_rows <- fetch_panel(HUMAN_PANEL, "Human")
  rodent_rows <- fetch_panel(RODENT_PANEL, "Rodent")
  panel_df <- rbind(human_rows, rodent_rows)

  # ---- write dataset panel table ----
  out_dir <- file.path(root, "results", "tables")
  dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)
  write.csv(panel_df, file.path(out_dir, "T1_dataset_panel.csv"), row.names = FALSE)
  cat(sprintf("\nWrote T1_dataset_panel.csv (%d studies)\n", nrow(panel_df)))
  cat(sprintf("  human: %d, rodent: %d\n", sum(panel_df$species=="human"), sum(panel_df$species=="mouse")))
  cat("\nNext: Rscript scripts/02_biomarker_identification.R\n")
}

main()
