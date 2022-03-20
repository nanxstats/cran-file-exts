# Cluster the most frequently used file extensions

library("oneclust")
library("DT")

x <- readLines("exts.txt")
x <- tolower(unlist(strsplit(x, split = "\t")))
y <- sort(table(x), decreasing = TRUE)

# A heavy-tailed distribution?
z <- y[y > 50L]
length(z) / length(y)
sum(z) / sum(y)

# Cluster the extensions of interest
eoi <- y[y > 4L]
cl <- oneclust(eoi, 4)

# Create a table
df <- data.frame(
  "ext" = names(eoi),
  "mime" = mime::guess_type(paste0(".", names(eoi))),
  "count" = as.vector(eoi),
  "cluster" = dplyr::recode(cl$cluster, `1` = 4, `2` = 3, `3` = 2, `4` = 1)
)

DT::datatable(
  df,
  rownames = FALSE,
  colnames = c("Extension", "Media Type", "Count", "Cluster")
) |>
  formatStyle(
    "cluster",
    color = styleEqual(
      unique(df$cluster), oneclust::cud()[unique(df$cluster)]
    )
  ) |>
  formatStyle(columns = c(1, 2, 3, 4), fontSize = "16px") |>
  formatStyle("mime", fontSize = "12px")
