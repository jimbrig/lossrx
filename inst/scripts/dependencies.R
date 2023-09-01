# Remotes ----
install.packages("remotes")
remotes::install_github('Displayr/flipTime')
remotes::install_github('rstudio/connections')
# Attachments ----
to_install <- c("cli", "config", "crayon", "dbx", "dplyr", "formattable", "fs", "glue", "here", "lubridate", "magrittr", "pool", "purrr", "randomNames", "readr", "rlang", "RPostgres", "shiny", "stringr", "tibble", "timevis", "usethis")
  for (i in to_install) {
    message(paste("looking for ", i))
    if (!requireNamespace(i, quietly = TRUE)) {
      message(paste("     installing", i))
      install.packages(i)
    }
  }

