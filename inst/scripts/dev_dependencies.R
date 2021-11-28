
#  ------------------------------------------------------------------------
#
# Title : Development Dependencies
#    By : Jimmy Briggs
#  Date : 2021-11-27
#
#  ------------------------------------------------------------------------

dev_deps <- c(
  "devtools",
  "usethis",
  "testthat",
  "roxygen2",
  "knitr",
  "rmarkdown",
  "dplyr",
  "tidyr",
  "shiny",
  "shinydashboard",
  "shinyWidgets",
  "lubridate",
  "stringr",
  "purrr",
  "attachment",
  "chameleon",
  "addinit",
  "assertive",
  "assertthat",
  "validate"
)

purrr::walk(dev_deps, pak::pak)
