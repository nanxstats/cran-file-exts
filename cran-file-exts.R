# Download all R packages on CRAN and collect the file extensions

library("curl")
library("tools")

repo <- "https://cloud.r-project.org/"
db <- as.data.frame(available.packages(paste0(repo, "src/contrib/")), stringsAsFactors = FALSE)
pkgs <- db$Package
files <- paste0(pkgs, "_", db$Version, ".tar.gz")
links <- paste0(repo, "src/contrib/", files)

find_ext <- function(path) {
  x <- unique(file_ext(untar(path, list = TRUE)))
  x[!(x %in% "")]
}

writeLines(pkgs, "pkgs.txt")

for (i in seq_along(pkgs)) {
  cat("Downloading", i, "/", length(pkgs), "\n")
  curl_download(links[i], destfile = files[i])
  x <- find_ext(files[i])
  write(paste0(x, collapse = "\t"), file = "exts.txt", append = TRUE)
  unlink(files[i])
}
