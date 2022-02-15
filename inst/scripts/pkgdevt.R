
#  ------------------------------------------------------------------------
#
# Title : `lossrx` R Package Development
#    By : Jimmy Briggs
#  Date : 2021-10-26
#
#  ------------------------------------------------------------------------


# package development libraries -------------------------------------------
require(devtools)
require(usethis)
require(pkgbuild)
require(roxygen2)
require(testthat)
require(knitr)
require(fs)
require(purrr)
require(attachment)
require(chameleon)
require(golem)

# initialize --------------------------------------------------------------

usethis::create_package("lossrx")
usethis::use_namespace()
usethis::use_roxygen_md()
usethis::use_git()
usethis::use_github()
usethis::use_package_doc()
usethis::use_tibble() # #' @return a [tibble][tibble::tibble-package]
usethis::use_pipe() # move to propaloc-package.R
usethis::use_tidy_eval() # move to propalloc-package.R
devtools::document()


# github labels -----------------------------------------------------------

usethis::use_github_labels(
  # delete_default = TRUE,
  labels = c("config", "release", "setup"), #,"data", "app", "api", "refactor"),
  colours = NULL, #c("config" = "#6A6CDE", "release" = "#12E943", "setup" = "#c5def5"), #, "data" = ""),
  descriptions = c("config" = "Configuration and meta-infrastructural changes",
                   "release" = "Indicates a new release",
                   "setup" = "Related to setting up the project/package"),
  rename = c("enhancement" = "feature")
)

# create some directories -------------------------------------------------

c(
  "inst/images",
  "inst/scripts",
  "inst/extdata",
  "inst/app",
  "inst/templates"
) %>%
  purrr::walk(fs::dir_create)

fs::file_create("inst/scripts/dev_dependencies.R")

devtools::document()

# DESCRIPTION -------------------------------------------------------------

desc::desc_set(Title = "Actuarial Loss Development and Reserving with R",
               Description = "Actuarial Loss Development and Reserving Helper Functions and ShinyApp.")

# package version
desc::desc_set_version("0.0.1")

#  R version
desc::desc_set("Depends", "R (>= 2.10)")

# license
# usethis::use_mit_license(name = "")

# normalize
desc::desc_normalize() # usethis::use_tidy_description()

# Docs --------------------------------------------------------------------

usethis::use_news_md()
usethis::use_pkgdown_github_pages()

# README ------------------------------------------------------------------

usethis::use_readme_rmd()
usethis::use_logo("inst/images/lossdevt.png")
usethis::use_lifecycle_badge("Experimental")
usethis::use_badge(
  "Project Status: WIP",
  href = "http://www.repostatus.org/#wip",
  src = "https://www.repostatus.org/badges/latest/wip.svg"
)
knitr::knit("README.Rmd")

# Package Dependencies ----------------------------------------------------

c(
  "dplyr",
  "magrittr",
  "rlang",
  "tibble",
  "lubridate",
  "purrr",
  "actuar",
  "ChainLadder",
  "stringr"
) |>
  purrr::walk(usethis::use_package)

usethis::use_dev_package("flipTime", remote = "Displayr/flipTime")

# Functions ---------------------------------------------------------------

c(
  "zzz",
  "utils-data",
  "utils-dates",
  "utils-feedback",
  "actuary-triangles",
  "actuary-interp",
  "actuary-validation",
  "actuary-simulate_claims",
  "actuary-loss_run",
  "db-connect",
  "db-config",
  "meta-open_pkgdown",
  "meta-data",
  "meta-globals"
) |>
  purrr::walk(usethis::use_r)

usethis::use_r("simulate_claims")

# Tests -------------------------------------------------------------------

usethis::use_testthat()

c(
  "date-utils",
  "data-utils",
  "actuary-triangle",
  "actuary-validation",
  "actuary-loss_run",
  "actuary-simulate_claims"
) |>
  purrr::walk(usethis::use_test)

# Vignettes ---------------------------------------------------------------

usethis::use_vignette("A-actuarial-loss-reserving-overview",
                      "Actuarial Loss Reserving Overview")

usethis::use_vignette("A-actuarial-loss-reserving-overview",
                      "Actuarial Loss Reserving Overview")

usethis::use_vignette("Lossruns-and-Triangles",
                      "Lossruns and Triangles")

usethis::use_vignette(
  "Data-Overview"
)



# Data --------------------------------------------------------------------

usethis::use_data_raw("claims")
usethis::use_r("data-claims")

usethis::use_data_raw("claims_transactional")


usethis::use_test("loss_run")
usethis::use_test("interp")

