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



#' losses
#'
# Actuarial loss runs.
#'
#' @format A `data.frame` with 79748 rows and 30 variables:
#' \describe{
#'   \item{\code{eval_date}}{double. DESCRIPTION.}
#'   \item{\code{devt_age}}{double. DESCRIPTION.}
#'   \item{\code{occurrence_number}}{character. DESCRIPTION.}
#'   \item{\code{coverage}}{character. DESCRIPTION.}
#'   \item{\code{member}}{character. DESCRIPTION.}
#'   \item{\code{program_year}}{character. DESCRIPTION.}
#'   \item{\code{loss_date}}{double. DESCRIPTION.}
#'   \item{\code{rept_date}}{double. DESCRIPTION.}
#'   \item{\code{hire_date}}{double. DESCRIPTION.}
#'   \item{\code{report_lag}}{double. DESCRIPTION.}
#'   \item{\code{report_lag_group}}{integer. DESCRIPTION.}
#'   \item{\code{day_of_week}}{character. DESCRIPTION.}
#'   \item{\code{claim_type}}{character. DESCRIPTION.}
#'   \item{\code{claimant_state}}{character. DESCRIPTION.}
#'   \item{\code{loss_state}}{character. DESCRIPTION.}
#'   \item{\code{cause}}{character. DESCRIPTION.}
#'   \item{\code{department}}{character. DESCRIPTION.}
#'   \item{\code{tenure}}{double. DESCRIPTION.}
#'   \item{\code{tenure_group}}{integer. DESCRIPTION.}
#'   \item{\code{claimant_age}}{double. DESCRIPTION.}
#'   \item{\code{claimant_age_group}}{integer. DESCRIPTION.}
#'   \item{\code{driver_age}}{double. DESCRIPTION.}
#'   \item{\code{driver_age_group}}{integer. DESCRIPTION.}
#'   \item{\code{status}}{character. DESCRIPTION.}
#'   \item{\code{total_paid}}{double. DESCRIPTION.}
#'   \item{\code{total_incurred}}{double. DESCRIPTION.}
#'   \item{\code{count}}{double. DESCRIPTION.}
#'   \item{\code{open_count}}{double. DESCRIPTION.}
#'   \item{\code{close_count}}{double. DESCRIPTION.}
#'   \item{\code{incurred_group}}{integer. DESCRIPTION.}
#' }
"losses"

#' exposures
#'
#' Exposure data.
#'
#' @format A `data.frame` with 855 rows and 5 variables:
#' \describe{
#'   \item{\code{member}}{character. DESCRIPTION.}
#'   \item{\code{program_year}}{double. DESCRIPTION.}
#'   \item{\code{department}}{character. DESCRIPTION.}
#'   \item{\code{payroll}}{double. DESCRIPTION.}
#'   \item{\code{miles}}{double. DESCRIPTION.}
#' }
"exposures"
