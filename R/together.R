library(tidyverse)
library(magrittr)
options(readr.show_col_types = FALSE)

wiki.imdb.nm <- read_csv("~/GitHub/Nitrate-SPARQL/output/wikidata-imdb-names.csv")
wiki.imdb.co <- read_csv("~/GitHub/Nitrate-SPARQL/output/wikidata-imdb-companies.csv")
wiki.imdb.tt <- read_csv("~/GitHub/Nitrate-SPARQL/output/wikidata-imdb-films.csv")
title_basics_tsv <- read_delim("~/Downloads/imdb/title.basics.tsv.gz",
                               delim = "\t", escape_double = FALSE,
                               trim_ws = TRUE)
name_basics_tsv <- read_delim("~/Downloads/imdb/name.basics.tsv.gz",
                              delim = "\t", escape_double = FALSE,
                              trim_ws = TRUE)

missing.co <-
  read_csv(list.files(pattern = "-companies.csv$", recursive = TRUE)) %>%
  bind_rows() %>%
  select(wikibase_item, CompanyID) %>%
  distinct() %>%
  left_join(
    wiki.imdb.co %>%
      rename(QID.imdb = imdb),
    by=c("wikibase_item" = "QID"),
    relationship = "many-to-many") %>%
  filter(is.na(QID.imdb)) %>%
  select(-QID.imdb) %>%
  filter(!CompanyID %in% wiki.imdb.co$imdb) %T>%
  write.csv(., paste0("outputs/missing-co.csv"), row.names = FALSE)

missing.nm <-
  read_csv(list.files(pattern = "-people.csv$", recursive = TRUE)) %>%
  bind_rows() %>%
  select(wikibase_item, PersonID) %>%
  left_join(name_basics_tsv, by=c("PersonID" = "nconst")) %>%
  distinct(PersonID, .keep_all = TRUE) %>%
  filter(!is.na(primaryName)) %>%
  filter(!PersonID %in% wiki.imdb.nm$imdb) %T>%
  write.csv(., paste0("outputs/missing-nm.csv"), row.names = FALSE)

missing.tt <-
  read_csv(list.files(pattern = "-films.csv$", recursive = TRUE)) %>%
  bind_rows() %>%
  select(title, wikibase_item, FilmID, status) %>%
  distinct() %>%
  left_join(title_basics_tsv, by=c("FilmID" = "tconst")) %>%
  filter(!FilmID %in% wiki.imdb.tt$imdb) %T>%
  write.csv(., paste0("outputs/missing-tt.csv"), row.names = FALSE)

rm(wiki.imdb.co, wiki.imdb.nm, wiki.imdb.tt)
rm(title_basics_tsv, name_basics_tsv)



