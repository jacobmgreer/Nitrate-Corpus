library(tidyverse)
library(jsonlite)

## use a wikipedia nightly: https://dumps.wikimedia.org/other/cirrussearch/

### R can unzip the gz file without any additional code,
### but I find it's faster to do that first outside R

filename <- "elwiki-20231009-cirrussearch-content.json" ## file name .gz or .json
lang <- "el" ## language short code

## deletes contents of lang folder and creates subfolders
unlink(paste0("outputs/", filename), recursive = TRUE, force = FALSE)
dir.create(file.path("outputs", lang), showWarnings = FALSE)
dir.create(file.path(paste0("outputs/", lang), "chunks"), showWarnings = FALSE)
dir.create(file.path(paste0("outputs/", lang), "compiled"), showWarnings = FALSE)
dir.create(file.path(paste0("outputs/", lang), "output"), showWarnings = FALSE)

###### separate the wiki dump into chunked Rdata files

f = function(x, pos){
  filename = paste0("outputs/", lang, "/chunks/chunk_", pos, ".RData", sep="")
  save(x, file = filename)
}

read_lines_chunked(
  file = paste0("nightly/", filename),
  chunk_size = 100000,
  callback = SideEffectChunkCallback$new(f),
  progress = show_progress())

#### deletes the nightly file once it's done being chunked
unlink(paste0("nightly/", filename), recursive = FALSE, force = FALSE)

rm(f)
