# After activating conda environment, run the following before running this script:
# export PATH="$CONDA_PREFIX/bin:$PATH"
# hash -r

library(vcfR)
library(UpSetR)

# Get command-line arguments
args <- commandArgs(trailingOnly = TRUE)

Truthset_snv_hc <- read.vcfR(args[1])
GATK_snv_hc <- read.vcfR(args[2])

hg19_chr <- c("chr19")

Truthset_snv_hc <- Truthset_snv_hc[
  Truthset_snv_hc@fix[, "CHROM"] %in% hg19_chr, ]

Truthset_snv_hc <-
  paste(Truthset_snv_hc@fix[, "CHROM"],
        Truthset_snv_hc@fix[, "POS"], sep = "_")

GATK_snv_hc <-
  paste(GATK_snv_hc@fix[, "CHROM"],
        GATK_snv_hc@fix[, "POS"], sep = "_")

read_sets <- list(
  Truthset_SNV = Truthset_snv_hc,
  GATK_snv_hc = GATK_snv_hc
)

upset(fromList(read_sets),
      order.by = "freq",
      keep.order = TRUE,
      sets = c("GATK_snv_hc", "Truthset_SNV"))
