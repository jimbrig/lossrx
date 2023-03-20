library(imaginator)
library(distributions3)

set.seed(12345)

tbl_policy <- policies_simulate(2, 2012:2022)

tbl_policy %>%
  head(5) %>%
  View()

tbl_claim_transactions <- claims_by_wait_time(
  tbl_policy,
  claim_frequency = 2,
  payment_frequency = 3,
  occurrence_wait = 10,
  report_wait = 5,
  pay_wait = 5,
  pay_severity = 50
)

tbl_claim_transactions_2 <- tbl_claim_transactions |>
  filter(policyholder_id == 1, lubridate::year(policy_effective_date) == 2001) |>
  select(claim_id, occurrence_date, report_date, payment_date, payment_amount)


tbl_claim_transactions_3 <- claims_by_wait_time(
  tbl_policy,
  claim_frequency = 2,
  payment_frequency = Poisson(2),
  occurrence_wait = Poisson(10),
  report_wait = Poisson(5),
  pay_wait = Poisson(5),
  pay_severity = LogNormal(log(50), 0.5 * log(50))) |>
  filter(policyholder_id == 1, lubridate::year(policy_effective_date) == 2001) |>
  select(claim_id, occurrence_date, report_date, payment_date, payment_amount)

tbl_policy_2 <- policies_simulate(2, 2012:2022)
lstFreq <- list(4, 3, 2, 1)
lstSev <- list(250)
lstSev[1:4] <- lstSev[1]

tbl_ibnyr_fixed <- claims_by_first_report(tbl_policy,
                                          frequency = lstFreq,
                                          payment_severity = lstSev,
                                          lags = 1:4)

tbl_ibnyr_fixed |>
  filter(policyholder_id == 1) |>
  filter(policy_effective_date == min(policy_effective_date)) |>
  View()
