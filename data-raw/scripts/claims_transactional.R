## code to prepare `claims_transactional` dataset goes here

#  ------------------------------------------------------------------------
#
# Title : Transactional Loss Data Simulation
#    By : Jimmy Briggs
#  Date : 2020-11-06
#
#  ------------------------------------------------------------------------

# simulate transactions on insurance claims
# transactions will include claim closures, payments and changes in case 
# reserves this is all completely made up and does not accurately resemble 
# actual claims
library(lubridate)
library(dplyr)
library(tibble)
library(randomNames)
library(tidyr)

# source("R/utils.R")
devtools::load_all()

# number of claims
n_claims <- 10000

# start/end dates & accident range
beg_date <- as.Date("2015-01-01")
end_date <- end_of_month(start_of_month(Sys.Date()) - 1)
accident_range <- as.numeric(end_date - beg_date)

set.seed(1234)

accident_date <- sample(0:accident_range, size = n_claims, replace = TRUE)

payment_fun <- function(n) rlnorm(n, 7.5, 1.5)

claims <- tibble::tibble(
  claim_num = 1:n_claims,
  claim_id = paste0("claim-", 1:n_claims),
  accident_date = beg_date + lubridate::days(accident_date),
  state = sample(c("TX", "CA", "GA", "FL"), size = n_claims, replace = TRUE),
  claimant = randomNames::randomNames(n_claims),
  report_date = rnbinom(n_claims, 5, .25),
  # 0 if claim closed when reported
  status = rbinom(n_claims, 1, 0.96),
  # initial payment amount
  payment =  payment_fun(n_claims)) %>%
  dplyr::mutate(report_date = accident_date + report_date,
                # set payment to zero if closed when reported
                payment = ifelse(status == 0, 0, payment),
                case = payment * runif(n_claims, 0.25, 8.0),
                transaction_date = report_date) %>%
  dplyr::arrange(accident_date)

## simulate transaction dates
# simulate number of transactions for each claim
n_trans <- rnbinom(n_claims, 3, 0.25)

# simulate lag to each transaction
trans_lag <- lapply(n_trans, function(x) rnbinom(x, 7, 0.1))
trans_lag <- lapply(trans_lag, function(x) {
  if (length(x) == 0) 0 else x
})

for (i in seq_len(n_claims)) {
  trans_lag[[i]] <- data_frame(
    "trans_lag" = trans_lag[[i]],
    "claim_id" = paste0("claim-", i),
    "claim_num" = i
  )
}

trans_tbl <- bind_rows(trans_lag) %>%
  group_by(claim_id, claim_num) %>%
  # switch from incremental to cumulative lag
  mutate(trans_lag = cumsum(trans_lag)) %>%
  ungroup()

# separate all zero claims from the claims that have payments
zero_claims <- dplyr::filter(claims, status == 0)
first_trans <- dplyr::filter(claims, status == 1)

subsequent_trans <- left_join(trans_tbl, first_trans, 
                              by = c("claim_num", "claim_id")) %>%
  filter(!is.na(accident_date))

n_trans <- nrow(subsequent_trans)

# simulate subsequent transaction payments
subsequent_trans <- subsequent_trans %>%
  mutate(payment = payment_fun(n_trans),
         case = pmax(case * rnorm(n_trans, 1.5, 0.1) - payment, 500),
         transaction_date = report_date + trans_lag) %>%
  select(-trans_lag)

trans <- bind_rows(zero_claims, first_trans, subsequent_trans) %>%
  arrange(transaction_date)

# add in a transaction number
trans$trans_num <- 1:nrow(trans)

# set final trans status to closed and case to 0
trans <- trans %>%
  arrange(trans_num) %>%
  group_by(claim_num, claim_id) %>%
  mutate(final_trans = ifelse(trans_num == max(trans_num), TRUE, FALSE),
         status = ifelse(final_trans, 0, 1),
         case = ifelse(final_trans, 0, case),
         status = ifelse(status == 0, "Closed", "Open"),
         paid = round(cumsum(payment), 0),
         case = round(case, 0),
         payment = round(payment, 0)) %>%
  select(-final_trans) %>%
  arrange(accident_date) %>%
  ungroup() %>%
  # filter out any transactions past latest eval
  filter(.data$transaction_date <= end_date)

fs::dir_create("data-raw/cache")
qs::qsave(trans, file = paste0("data-raw/cache/", Sys.Date(), 
                               "-transactional-claims.qs"))

claims_transactional <- trans
usethis::use_data(claims_transactional, overwrite = TRUE)
