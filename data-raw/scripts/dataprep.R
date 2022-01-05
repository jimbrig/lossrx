
#  ------------------------------------------------------------------------
#
# Title : Fetch Stashed Loss and Exposure Data from Github Release
#    By : Jimmy Briggs
#  Date : 2022-01-03
#
#  ------------------------------------------------------------------------

library(dplyr)
require(piggyback)

piggyback::pb_download(
  "loss_and_exposure_data.zip",
  repo = "jimbrig/lossrx",
  dest = "data-raw",
  overwrite = TRUE
)

fs::dir_create("data-raw/downloaded")
fs::dir_create("data-raw/extracted")

unzip(
  file.path("data-raw", "loss_and_exposure_data.zip"),
  exdir = file.path("data-raw", "extracted")
)

exposures <- qs::qread("data-raw/extracted/exposures_scrubbed")
losses <- qs::qread("data-raw/extracted/loss_data_scrubbed")

losses <- losses |>
  mutate(
    occurrence_number = extract_num(occurrence_number)
  )

usethis::use_data(exposures)
usethis::use_data(losses, overwrite = TRUE)

doc_data(losses)
doc_data(exposures)

library(mockaRoo)
library(uuid)

basicSchema <- data.frame(
  claimant_id = uuid::UUIDgenerate(n = 1),
  claimant_first_name = "John",
  claimant_last_name = "Doe"
  )

response <- mockaRoo::mockaroo("csv", list(key = "de7c9b30", count = 10), schema = jsonlite::toJSON(basicSchema))

jsonlite::prettify(response)


mockaRoo::mockaroo()

claimants <-

  search_ghr("mockaroo")

basicSchema<-list(
  name = "blah"
  , percentBlank = 0
  , type = "Color"
)

library(mockaRoo)

mockaRoo::mockaroo("json"
         , list( key = "de7c9b30"
                 , count = 10)
         , schema = jsonlite::toJSON(basicSchema)
)
