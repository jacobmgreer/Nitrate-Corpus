library(tidyverse)
library(jsonlite)

## deletes contents of lang folder and creates subfolders
unlink(paste0("outputs/", lang), recursive = TRUE, force = FALSE)
dir.create(file.path("outputs", lang), showWarnings = FALSE)
dir.create(file.path(paste0("outputs/", lang), "chunks"), showWarnings = FALSE)
dir.create(file.path(paste0("outputs/", lang), "compiled"), showWarnings = FALSE)

###### separate the wiki dump into chunked Rdata files

f = function(x, pos){
  filename = paste0("outputs/", lang, "/chunks/chunk_", pos, ".RData", sep="")
  save(x, file = filename)
}

read_lines_chunked(
  file = paste0("nightly/", list.files("nightly", pattern=paste0("^", lang))),
  chunk_size = 100000,
  callback = SideEffectChunkCallback$new(f),
  progress = show_progress())

#### deletes the nightly file once it's done being chunked
unlink(paste0("nightly/", list.files("nightly", pattern=paste0("^", lang))), recursive = FALSE, force = FALSE)

rm(f)
