
#' claims_transactional
#'
#' Transactional claims dataset. Convert to a static `lossrun` using the
#' [lossrx::loss_run()] function.
#'
#' @format A `data.frame` with 80278 rows and 12 variables:
#' \describe{
#'   \item{\code{claim_num}}{integer. DESCRIPTION.}
#'   \item{\code{claim_id}}{character. DESCRIPTION.}
#'   \item{\code{accident_date}}{double. DESCRIPTION.}
#'   \item{\code{state}}{character. DESCRIPTION.}
#'   \item{\code{claimant}}{character. DESCRIPTION.}
#'   \item{\code{report_date}}{double. DESCRIPTION.}
#'   \item{\code{status}}{character. DESCRIPTION.}
#'   \item{\code{payment}}{double. DESCRIPTION.}
#'   \item{\code{case}}{double. DESCRIPTION.}
#'   \item{\code{transaction_date}}{double. DESCRIPTION.}
#'   \item{\code{trans_num}}{integer. DESCRIPTION.}
#'   \item{\code{paid}}{double. DESCRIPTION.}
#' }
"claims_transactional"

#' auto_claims
#'
#' Auto Liability Claims Data from original source [trafficaccidents::event]
#'
#' @format A `data.frame` with 404704 rows and 18 variables:
#' \describe{
#'   \item{\code{accident_year}}{integer. DESCRIPTION.}
#'   \item{\code{claim_id}}{integer. DESCRIPTION.}
#'   \item{\code{injury_level}}{integer. DESCRIPTION.}
#'   \item{\code{accident_date}}{double. DESCRIPTION.}
#'   \item{\code{accident_hour}}{integer. DESCRIPTION.}
#'   \item{\code{accident_in_city}}{integer. DESCRIPTION.}
#'   \item{\code{accident_road_type}}{integer. DESCRIPTION.}
#'   \item{\code{accident_location_id}}{integer. DESCRIPTION.}
#'   \item{\code{accident_road_section_id}}{integer. DESCRIPTION.}
#'   \item{\code{accident_location_type}}{integer. DESCRIPTION.}
#'   \item{\code{accident_cause}}{integer. DESCRIPTION.}
#'   \item{\code{accident_event_type}}{integer. DESCRIPTION.}
#'   \item{\code{accident_weather}}{integer. DESCRIPTION.}
#'   \item{\code{accident_traffic}}{integer. DESCRIPTION.}
#'   \item{\code{accident_surface_conditions}}{integer. DESCRIPTION.}
#'   \item{\code{accident_surface}}{integer. DESCRIPTION.}
#'   \item{\code{accident_lat}}{double. DESCRIPTION.}
#'   \item{\code{accident_lon}}{double. DESCRIPTION.}
#' }
"auto_claims"
