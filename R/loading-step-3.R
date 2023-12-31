library(tidyverse)
library(jsonlite)
library(magrittr)
library(qdapRegex)

## combines the chunks into one list

films <-
  list.files(paste0("outputs/", lang, "/compiled"), "*.csv") %>%
  map_df(~read_csv(paste0("outputs/", lang, "/compiled/", .), show_col_types = FALSE)) %>%
  mutate(source_text = gsub("\\s+", " ", str_trim(source_text))) %>%
  arrange(desc(popularity_score)) %T>%
  write.csv(., paste0("outputs/", lang, "/wiki-imdb-films-raw.csv"), row.names = FALSE)

unlink(file.path(paste0("outputs/", lang), "compiled"), recursive = TRUE, force = FALSE)
