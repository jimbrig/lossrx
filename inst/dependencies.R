# Remotes ----
install.packages("remotes")
remotes::install_github('Displayr/flipTime')
# Attachments ----
to_install <- c("cli", "crayon", "dbx", "dplyr", "fs", "glue", "here", "lubridate", "magrittr", "purrr", "readr", "rlang", "stringr", "tibble", "usethis")
  for (i in to_install) {
    message(paste("looking for ", i))
    if (!requireNamespace(i)) {
      message(paste("     installing", i))
      install.packages(i)
    }
  }
