
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

# initialize --------------------------------------------------------------

usethis::create_package("lossrx")

usethis::use_git()
usethis::use_github()
usethis::use_namespace()
usethis::use_roxygen_md()

usethis::use_testthat()
usethis::use_data_raw("claims")
usethis::use_vignette("A-actuarial-loss-reserving-overview", "Actuarial Loss Reserving Overview")

usethis::use_package_doc()
usethis::use_tibble() # #' @return a [tibble][tibble::tibble-package]
usethis::use_pipe() # move to propaloc-package.R
usethis::use_tidy_eval() # move to propalloc-package.R
devtools::document()

# create some directories -------------------------------------------------

c(
  "inst/images",
  "inst/scripts",
  "inst/extdata",
  "inst/app",
  "inst/templates"
) %>%
  purrr::walk(fs::dir_create)

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


# Misc --------------------------------------------------------------------

usethis::use_news_md()
