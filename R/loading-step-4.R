library(tidyverse)
library(jsonlite)
library(magrittr)
library(qdapRegex)

options(readr.show_col_types = FALSE)

name_basics_tsv <- read_delim("~/Downloads/imdb/name.basics.tsv.gz",
                              delim = "\t", escape_double = FALSE,
                              trim_ws = TRUE)
title_basics_tsv <- read_delim("~/Downloads/imdb/title.basics.tsv.gz",
                              delim = "\t", escape_double = FALSE,
                              trim_ws = TRUE)

find.imdb.tt <-
  films %>%
  filter(grepl("imdb.com/title", external_link)) %>%
  filter(!grepl("season|list|series|filmography|franchise", title, ignore.case = TRUE)) %>%
  filter(grepl("classification.ores.articletopic/Culture.Media.Films", weighted_tags)) %>%
  mutate(
    FilmID = str_extract_all(external_link, "(?<=title/tt)\\d+")) %>%
  unnest(FilmID) %>%
  mutate(
    FilmID = paste0("tt", FilmID)) %>%
  select(
    !c(name, source_text, text, opening_text, external_link, text_bytes, popularity_score)) %>%
  left_join(
    title_basics_tsv %>%
      select(tconst, primaryTitle),
    by=c("FilmID" = "tconst")) %>%
  mutate(
    status = ifelse(title == primaryTitle, "match", "not exact match")) %>%
  distinct() %>%
  left_join(
    read_csv("~/GitHub/Nitrate-SPARQL/output/wikidata-films-imdb.csv") %>% rename(QID.imdb = imdb),
    by=c("wikibase_item" = "QID"),
    relationship = "many-to-many") %>%
  mutate(
    imdb.status = ifelse(FilmID == QID.imdb, "match", NA)) %>%
  filter(is.na(QID.imdb)) %>%
  group_by(wikibase_item) %>% filter(!(n() > 1)) %>% ungroup() %T>%
  write.csv(., paste0("outputs/", lang, "/output/", lang, "-wiki-imdb-films.csv"), row.names = FALSE)

find.imdb.co <-
  films %>%
  filter(
    grepl("imdb.com/company", external_link)) %>%
  mutate(
    CompanyID = str_extract_all(external_link, "(?<=company/co)\\d+")) %>%
  unnest(CompanyID) %>%
  mutate(
    CompanyID = paste0("co", CompanyID)) %>%
  select(
    !c(name, weighted_tags, source_text, text, opening_text, external_link, text_bytes, popularity_score)) %>%
  distinct() %>%
  left_join(
    read_csv("~/GitHub/Nitrate-SPARQL/output/wikidata-films-imdb.csv") %>% rename(QID.imdb = imdb),
    by=c("wikibase_item" = "QID"),
    relationship = "many-to-many") %>%
  filter(is.na(QID.imdb)) %>%
  group_by(wikibase_item) %>% filter(!(n() > 1)) %>% ungroup() %T>%
  write.csv(., paste0("outputs/", lang, "/output/", lang, "-wiki-imdb-companies.csv"), row.names = FALSE)

find.imdb.nm <-
  films %>%
  filter(grepl("imdb.com/name", external_link)) %>%
  filter(grepl("classification.ores.articletopic/Culture.Biography.Biography", weighted_tags)) %>%
  mutate(
    PersonID = str_extract_all(external_link, "(?<=name/nm)\\d+")) %>%
  unnest(PersonID) %>%
  mutate(
    PersonID = paste0("nm", PersonID)) %>%
  select(
    !c(name, source_text, text, opening_text, external_link, text_bytes, popularity_score)) %>%
  left_join(
    name_basics_tsv %>%
      select(nconst, primaryName),
    by=c("PersonID" = "nconst")) %>%
  mutate(
    status = ifelse(title == primaryName, "match", "not exact match")) %>%
  distinct() %>%
  left_join(
    read_csv("~/GitHub/Nitrate-SPARQL/output/wikidata-films-imdb.csv") %>% rename(QID.imdb = imdb),
    by=c("wikibase_item" = "QID"),
    relationship = "many-to-many") %>%
  mutate(
    imdb.status = ifelse(PersonID == QID.imdb, "match", NA)) %>%
  group_by(wikibase_item) %>% filter(!(n() > 1)) %>% ungroup() %>%
  filter(is.na(imdb.status)) %T>%
  write.csv(., paste0("outputs/", lang, "/output/", lang, "-wiki-imdb-people.csv"), row.names = FALSE)

find.wiki.prod <-
  films %>%
  mutate(
    Studio = str_extract(source_text, "studio = [^_]+?(?=\\|)")) %>%
  filter(
    !is.na(Studio)) %>%
  select(
    !c(name, weighted_tags, source_text, text, opening_text, external_link, text_bytes, popularity_score)) %T>%
  write.csv(., paste0("outputs/", lang, "/output/", lang, "-wiki-prod.csv"), row.names = FALSE)

find.wiki.dist <-
  films %>%
  mutate(
    Distributor = str_extract(source_text, "distributor = [^_]+?(?=\\|)")) %>%
  filter(
    !is.na(Distributor)) %>%
  select(
    !c(name, weighted_tags, source_text, text, opening_text, external_link, text_bytes, popularity_score)) %T>%
  write.csv(., paste0("outputs/", lang, "/output/", lang, "-wiki-dist.csv"), row.names = FALSE)

rm(title_basics_tsv, name_basics_tsv)

