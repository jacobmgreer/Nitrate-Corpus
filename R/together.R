library(tidyverse)
library(magrittr)
options(readr.show_col_types = FALSE)

list <- list.files(pattern = "-companies.csv$", recursive = TRUE)

companies <-
  read_csv(list) %>%
  bind_rows() %>%
  select(wikibase_item, CompanyID) %>%
  distinct() %>%
  left_join(
    read_csv("~/GitHub/Nitrate-SPARQL/output/wikidata-imdb-companies.csv") %>% rename(QID.imdb = imdb),
    by=c("wikibase_item" = "QID"),
    relationship = "many-to-many") %>%
  filter(is.na(QID.imdb))




rm(list)
