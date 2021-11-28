# Download all R packages on CRAN and collect the file extensions

library("curl")
library("tools")

repo <- "https://cran.rstudio.com/"
db <- as.data.frame(available.packages(paste0(repo, "src/contrib/")), stringsAsFactors = FALSE)
pkgs <- db$Package
files <- paste0(pkgs, "_", db$Version, ".tar.gz")
links <- paste0(repo, "src/contrib/", files)

find_ext <- function(path) {
  x <- unique(file_ext(untar(path, list = TRUE)))
  x[!(x %in% "")]
}

for (i in seq_along(pkgs)) {
  cat("Downloading", i, "/", length(pkgs), "\n")
  curl_download(links[i], destfile = files[i])
  x <- find_ext(files[i])
  write(paste0(x, collapse = "\t"), file = "exts.txt", append = TRUE)
  unlink(files[i])
}

x <- readLines("exts.txt")
x <- tolower(unlist(strsplit(x, split = "\t")))
y <- sort(table(x), decreasing = TRUE)
length(y)
z <- y[y > 10L]
sum(z)/sum(y)
z
cat(names(z), sep = "\n")
