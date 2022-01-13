
#  ------------------------------------------------------------------------
#
# Title : Fetch Stashed Loss and Exposure Data from Github Release
#    By : Jimmy Briggs
#  Date : 2022-01-03
#
#  ------------------------------------------------------------------------

library(dplyr)
require(piggyback)

fs::dir_create("data-raw/original/downloaded")
fs::dir_create("data-raw/original/extracted")

piggyback::pb_download(
  file = "loss_and_exposure_data.zip",
  dest = "data-raw/original/downloaded",
  repo = "jimbrig/lossrx",
  tag = "v0.0.2",
  overwrite = TRUE
)

unzip(
  file.path("data-raw", "original", "downloaded", "loss_and_exposure_data.zip"),
  exdir = file.path("data-raw", "original", "extracted")
)

exposures <- qs::qread("data-raw/original/extracted/exposures_scrubbed")
losses <- qs::qread("data-raw/original/extracted/loss_data_scrubbed")

losses <- losses |>
  mutate(
    occurrence_number = extract_num(occurrence_number)
  )

losses_by_eval <- split(losses, losses$eval_date)
csv_dir <- fs::path("data-raw", "working", "lossruns", "CSV")
fs::dir_create(csv_dir)
csv_files <- paste0(csv_dir, "/", names(losses_by_eval), ".csv")
purrr::walk2(losses_by_eval, csv_files, vroom::vroom_write)


usethis::use_data(exposures)
usethis::use_data(losses, overwrite = TRUE)

doc_data(losses)
doc_data(exposures)


