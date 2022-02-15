#' View an Individual Claim's History
#'
#' This is a comprehensive function that allows the user to gain valuable insights
#' about an individual claim's historical transactions.
#'
#' @param claim_id Claim ID
#' @param claims_data Dataset
#'
#' @return a list containing a) claim details b) transactional history c) interactive timeline
#' @export
#'
#' @importFrom dplyr arrange filter distinct select pull mutate rowwise lag transmute case_when
#' @importFrom formattable currency
#' @importFrom lubridate as_date
#' @importFrom shiny HTML
#' @importFrom timevis timevis
view_claim_history <- function(claim_id, claims_data = NULL) {

  if (is.null(claims_data)) {
    claims_data <- claims_transactional
  }

  claim_dat <- dplyr::filter(claims_data, .data$claim_id == .env$claim_id) |>
    dplyr::arrange(.data$transaction_date)

  claim_details <- dplyr::select(claim_dat,
                                 `Claim ID` = .data$claim_id,
                                 `Claimant` = .data$claimant,
                                 `State` = .data$state,
                                 `Accident Date` = .data$accident_date,
                                 `Report Date` = .data$report_date) |>
    dplyr::distinct()

  close_date <- dplyr::filter(claim_dat, .data$status == "Closed") |>
    dplyr::pull(.data$transaction_date) |>
    lubridate::as_date()

  if (length(close_date) == 0) close_date <- "N/A"

  claim_details <- claim_details |> dplyr::mutate(`Close Date` = .env$close_date)

  claim_trans_hist <- dplyr::mutate(
    claim_dat,
    reported = .data$paid + .data$case,
    incr_rept = .data$reported - dplyr::lag(.data$reported, default = 0, order_by = .data$transaction_date),
    incr_case = .data$case - dplyr::lag(.data$case, default = 0, order_by = .data$transaction_date),
    incr_status = paste0(dplyr::lag(.data$status, default = "NEW", order_by = .data$transaction_date), " -> ", .data$status),
    status_details = dplyr::case_when(
      .data$incr_status == "NEW -> Open" ~ "Status: Claim Opened",
      .data$incr_status == "Open -> Open" ~ "Status: No Change",
      .data$incr_status == "Closed -> Closed" ~ "Status: No Change",
      .data$incr_status == "Closed -> Open" ~ "Status: Claim Re-Opened",
      .data$incr_status == "Open -> Closed" ~ "Status: Claim Closed"
    ),
    rept_details = case_when(
      .data$incr_rept == 0 ~ "Reported: No Change",
      .data$incr_rept > 0 ~ paste0("Reported: Increased by ", as.character(formattable::currency(.data$incr_rept))),
      .data$incr_rept < 0 ~ paste0("Reported: Decreased by ", as.character(formattable::currency(.data$incr_rept)))
    ),
    paid_details = case_when(
      .data$payment == 0 ~ "Paid: No Change",
      .data$payment > 0 ~ paste0("Paid: Increased by ", as.character(formattable::currency(.data$payment))),
      .data$payment < 0 ~ paste0("Paid: Decreased by ", as.character(formattable::currency(.data$payment)))
    ),
    case_details = case_when(
      .data$incr_case == 0 ~ "Case Reserve: No Change",
      .data$incr_case > 0 ~ paste0("Case Reserve: Increased by ", as.character(formattable::currency(.data$incr_case))),
      .data$incr_case < 0 ~ paste0("Case Reserve: Decreased by ", as.character(formattable::currency(.data$incr_case)))
    )
  ) |>
    dplyr::rowwise() |>
    dplyr::mutate(
      details = paste0(
        .data$paid_details, ";<br>", .data$case_details, ";<br>", .data$rept_details, ";<br>", .data$status_details
      )
    ) |>
    dplyr::select(
      `Transaction Date` = .data$transaction_date,
      `Transaction ID` = .data$trans_num,
      `Paid Change` = .data$payment,
      `Paid Details` = .data$paid_details,
      `Case Reserve Change` = .data$incr_case,
      `Case Reserve Details` = .data$case_details,
      `Reported Change` = .data$incr_rept,
      `Reported Details` = .data$rept_details,
      `Status Change` = .data$incr_status,
      `Status Details` = .data$status_details,
      `Status` = .data$status,
      `Cumulative Paid` = .data$paid,
      `Cumulative Case Reserve` = .data$case,
      `Cumulative Reported` = .data$reported,
      `Transaction Details` = .data$details
    )

  trans_hist_out <- dplyr::select(
    claim_trans_hist,
    -c(.data$`Transaction ID`,
       .data$`Paid Change`,
       .data$`Case Reserve Change`,
       .data$`Reported Change`,
       .data$`Status Details`,
       .data$`Status`,
       .data$`Transaction Details`)
  )

  timeline <- dplyr::transmute(
    claim_trans_hist,
    id = .data$`Transaction ID`,
    content = .data$`Transaction Date`,
    start = .data$`Transaction Date`,
    title = shiny::HTML(.data$`Transaction Details`)
  ) |>
    timevis::timevis(options = list("tooltip.overflowMethod" = "none"))

  list(
    "Details" = claim_details,
    "Transactions" = trans_hist_out,
    "Timeline" = timeline
  )

}
