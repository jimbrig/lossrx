# Remotes ----
install.packages("remotes")
remotes::install_github('Displayr/flipTime')
# Attachments ----
to_install <- c("cli", "crayon", "fs", "glue", "here", "lubridate", "magrittr", "rlang", "stringr", "tibble")
  for (i in to_install) {
    message(paste("looking for ", i))
    if (!requireNamespace(i)) {
      message(paste("     installing", i))
      install.packages(i)
    }
  }
