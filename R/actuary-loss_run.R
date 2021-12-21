#' loss_run
#'
#' view losses as of a specific date
#'
#' @param val_date date the valuation date of the loss run.  Claim values from `trans`
#' will be values as of the `val_date`
#' @param trans_dat data frame of claims transactions
#'
#' @return data frame of claims (1 claim per row) valued as of the `val_date`
#'
#' @importFrom dplyr filter group_by top_n ungroup mutate arrange desc select everything
#' @importFrom lubridate ymd year
loss_run <- function(val_date, trans_dat) {
  out <- trans_dat |>
    dplyr::filter(.data$transaction_date <= .env$val_date) |>
    dplyr::group_by(.data$claim_num) |>
    dplyr::top_n(1, wt = .data$trans_num) |>
    dplyr::ungroup() |>
    dplyr::mutate(reported = .data$paid + .data$case,
                  eval_date = lubridate::ymd(as.character(.env$val_date)),
                  case = .data$reported - .data$paid,
                  accident_year = lubridate::year(.data$accident_date),
                  report_year = lubridate::year(.data$report_date),
                  eval_year = lubridate::year(.data$eval_date),
                  ay_start = lubridate::ymd(paste0(as.character(lubridate::year(.data$accident_date)), "-01-01")),
                  ay_end = lubridate::ymd(paste0(as.character(lubridate::year(.data$accident_date)), "-12-31")),
                  ay_avg = lubridate::ymd(paste0(as.character(lubridate::year(.data$accident_date)), "-07-01")),
                  devt_in_days = as.numeric(.data$eval_date - .data$ay_avg),
                  devt = round(.data$devt_in_days / 365.25 * 12, 0) + 6) |>
    dplyr::arrange(dplyr::desc(.data$transaction_date), .data$claim_num, dplyr::desc(.data$eval_date)) |>
    dplyr::select(.data$eval_date, dplyr::everything())
}
