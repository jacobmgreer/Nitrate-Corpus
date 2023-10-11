library(tidyverse)
library(jsonlite)

## use a wikipedia nightly: https://dumps.wikimedia.org/other/cirrussearch/

###### separate the wiki dump into chunked Rdata files

f = function(x, pos){
  filename = paste("input/wiki-chunks/chunk_", pos, ".RData", sep="")
  save(x, file = filename)
}

read_lines_chunked(
  file = 'input/enwiki-20231002-cirrussearch-content.json',
  chunk_size = 100000,
  callback = SideEffectChunkCallback$new(f),
  progress = show_progress())

rm(f)
