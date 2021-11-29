# Cluster the most frequently used file extensions

library("oneclust")
library("reactable")

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

reactable(
  df,
  searchable = TRUE,
  pagination = TRUE,
  showSortIcon = TRUE,
  theme = reactableTheme(
    style = list(
      fontFamily = "'DM Sans', sans-serif",
      fontSize = "18px"
    )
  ),
  columns = list(
    ext = colDef(
      name = "File Extension"
    ),
    mime = colDef(
      name = "Media Type"
    ),
    count = colDef(
      name = "Count",
      style = list(
        fontFamily = "'DM Mono', monospace"
      )
    ),
    cluster = colDef(
      name = "Cluster",
      style = function(value) {
        list(
          color = oneclust::cud(value),
          fontFamily = "'DM Mono', monospace"
        )
      }
    )
  )
)
