
#  ------------------------------------------------------------------------
#
# Title : Package Build Preparation
#    By : Jimmy Briggs
#  Date : 2021-11-27
#
#  ------------------------------------------------------------------------


# dependencies ------------------------------------------------------------

attachment::att_amend_desc(
  extra.suggests = c(
    "roxygen2",
    "devtools",
    "usethis",
    "desc",
    "attachment",
    "testthat",
    "pkgdown",
    "covr",
    "spelling"
  ),
  use.config = TRUE,
  path.c = "inst/config/attachment.config.yml"
)

attachment::create_dependencies_file(to = "inst/scripts/dependencies.R")


# pkgdown -----------------------------------------------------------------

usethis::use_pkgdown("_pkgdown.yml", destdir = "docs")
pkgdown::clean_site()
pkgdown::build_site()

chameleon::build_pkgdown(yml = "_pkgdown.yml", favicon = "pkgdown/favicon")
chameleon::open_pkgdown_function()


# actions -----------------------------------------------------------------

usethis::use_pkgdown_github_pages()
usethis::use_github_action("test-coverage")
usethis::use_github_action_check_standard()
knitr::knit("README.Rmd")



# spellcheck --------------------------------------------------------------

devtools::load_all()
devtools::document()

devtools::spell_check()
spelling::update_wordlist()


# globals -----------------------------------------------------------------

globals <- checkhelper::get_no_visible() # remotes::install_github("thinkr-open/checkhelper")
globals_out <- paste0('"', unique(globals$globalVariables$variable), '"')
cat(globals_out, file = "R/globals.R", sep = "\n", append = TRUE)
usethis::edit_file("R/globals.R")

# build -------------------------------------------------------------------

devtools::load_all()
devtools::document()
devtools::check()
devtools::test()
devtools::lint()
devtools::build()
devtools::release()
