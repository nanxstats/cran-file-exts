# Compare extensions listed in pkglite vs. current CRAN packages
exts_pkglite <- tolower(union(
  unlist(pkglite::ext_binary(), use.names = FALSE),
  unlist(pkglite::ext_text(), use.names = FALSE)
))

exts_cran <- readLines("exts.txt") |>
  strsplit(split = "\t") |>
  unlist() |>
  tolower()

diff_set <- setdiff(exts_cran, exts_pkglite)
diff_all <- exts_cran[exts_cran %in% diff_set]
DT::datatable(as.data.frame(table(diff_all)))
