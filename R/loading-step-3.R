library(tidyverse)
library(jsonlite)
library(magrittr)
library(qdapRegex)

## combines the chunks into one list

films <-
  list.files("output/wiki-exports", "*.csv") %>%
  map_df(~read_csv(paste0("output/wiki-exports/", .), show_col_types = FALSE)) %>%
  mutate(source_text = gsub("\\s+", " ", str_trim(source_text))) %>%
  arrange(desc(popularity_score))
