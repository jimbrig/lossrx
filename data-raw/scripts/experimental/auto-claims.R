
#  ------------------------------------------------------------------------
#
# Title : Auto Liability Claims Data
#    By : Jimmy Briggs
#  Date : 2021-12-14
#
#  ------------------------------------------------------------------------


library(dplyr)
library(purrr)
library(stringr)

# use the trafficaccidents package for some data
# devtools::install_github("bergant/trafficaccidents")
# pak::pak("bergant/trafficaccidents")
require(trafficaccidents)

events <- trafficaccidents::event
parties <- trafficaccidents::party
dates <- trafficaccidents::calendar

auto_data <- list(
  accidents = events,
  involved_parties = parties,
  date_lookups = dates
)

usethis::use_data(auto_data)

compare_cols <- function(x, y, what = c(NA, "shared", "missing_x", "missing_y")) {
  what <- match.arg(what)
  nx <- names(x)
  ny <- names(y)
  same <- unique(names(x)[names(x) %in% names(y)], names(y)[names(y) %in% names(x)])
  only_x <- setdiff(names(x), same)
  only_y <- setdiff(names(y), same)
  out <- list(
    "shared" = same,
    "missing_y" = only_y,
    "missing_x" = only_x
  )
  if (is.na(what)) return(out)
  if (what == "shared") return(out$shared)
  if (what == "missing_x") return(out$missing_x)
  if (what == "missing_y") return(out$missing_y)
  invisible()
}

auto_claims <- auto_data$accidents |>
  transmute(
    accident_year = as.integer(src_file),
    claim_id = event_id,
    injury_level = injury,
    accident_date = date,
    accident_hour = hour,
    accident_in_city = in_city,
    accident_road_type = road_type,
    accident_location_id = location_id,
    accident_road_section_id = road_section_id,
    accident_location_type = location_type,
    accident_cause = cause,
    accident_event_type = event_type,
    accident_weather = weather,
    accident_traffic = traffic,
    accident_surface_conditions = surface_conditions,
    accident_surface = surface,
    accident_lat = lat,
    accident_lon = lon
  )

usethis::use_data(auto_claims, overwrite = TRUE)

doc_data(auto_claims, description = "Auto Liability Claims Data from original source [trafficaccidents::event]")

# auto_claims <- purrr::reduce(auto_data, left_join) |>
#   dplyr::mutate(
#     accident_year = as.integer(src_file)
#   ) |>
#   dplyr::select(-src_file, accident_year, dplyr::everything())
#
# summarytools::view(summarytools::dfSummary(auto_claims))
#
#
#
#
#   )
#
# compare_cols(events, parties, "shared")
#
#
#
# auto_claims <- events |>
#   transmute(
#
#   ) |>
#   left_join(
#     select(
#       parties,
#       accident_year = as.integer(src_file),
#       claim_id = event_id,
#       accident_role = accident_role,
#
#
#       )
#   )
#
#
#
#

