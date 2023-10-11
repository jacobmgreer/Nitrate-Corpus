library(tidyverse)
library(jsonlite)
library(magrittr)

##### Unpacking the RData json data
filelist <- list.files("input/wiki-chunks", pattern="RData$", full.names = FALSE, recursive = FALSE)

for (i in 1:length(filelist)) {

  get(load(paste0("input/wiki-chunks/", filelist[i]))) %>%
    enframe %>%
    unnest(cols = c(value)) %>%
    filter(!grepl('^\\{\"index\"', value)) %>%
    rowwise() %>%
    mutate(data = list(fromJSON(value))) %>%
    unnest_wider(data) %>%
    select(name, title, weighted_tags, wikibase_item, source_text, text,
           opening_text, external_link, text_bytes, popularity_score) %>%
    filter(grepl("imdb.com/", external_link)) %>%
    rowwise %>%
    mutate_if(is.list, ~paste(unlist(.), collapse = '|')) %>%
    write.csv(., paste0("output/wiki-exports/film-list-", i, ".csv"), row.names = FALSE)

  message(paste("Run", i, "completed!"))
}

rm(i, filelist, x)
