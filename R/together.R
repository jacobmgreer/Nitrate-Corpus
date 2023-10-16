library(tidyverse)
library(magrittr)
options(readr.show_col_types = FALSE)

missing.co <-
  read_csv(list.files(pattern = "-companies.csv$", recursive = TRUE)) %>%
  bind_rows() %>%
  select(wikibase_item, CompanyID) %>%
  distinct() %>%
  left_join(
    read_csv("~/GitHub/Nitrate-SPARQL/output/wikidata-imdb-companies.csv") %>% rename(QID.imdb = imdb),
    by=c("wikibase_item" = "QID"),
    relationship = "many-to-many") %>%
  filter(is.na(QID.imdb)) %T>%
  write.csv(., paste0("outputs/missing-co.csv"), row.names = FALSE)

missing.nm <-
  read_csv(list.files(pattern = "-people.csv$", recursive = TRUE)) %>%
  bind_rows() %>%
  select(wikibase_item, PersonID, primaryName) %>%
  distinct() %>%
  left_join(
    read_csv("~/GitHub/Nitrate-SPARQL/output/wikidata-imdb-names.csv") %>% rename(QID.imdb = imdb),
    by=c("wikibase_item" = "QID"),
    relationship = "many-to-many") %>%
  filter(is.na(QID.imdb)) %T>%
  write.csv(., paste0("outputs/missing-nm.csv"), row.names = FALSE)

missing.tt <-
  read_csv(list.files(pattern = "-films.csv$", recursive = TRUE)) %>%
  bind_rows() %>%
  select(wikibase_item, FilmID) %>%
  distinct() %>%
  left_join(
    read_csv("~/GitHub/Nitrate-SPARQL/output/wikidata-imdb-films.csv") %>% rename(QID.imdb = imdb),
    by=c("wikibase_item" = "QID"),
    relationship = "many-to-many") %>%
  filter(is.na(QID.imdb)) %T>%
  write.csv(., paste0("outputs/missing-tt.csv"), row.names = FALSE)

