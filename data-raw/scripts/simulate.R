# pak::pak("casact/imaginator")
# pak::pak("kasaai/simulationmachine")
# pak::pak("kasaai/conjuror")

library(imaginator)
library(dplyr)
library(simulationmachine)
library(conjuror)

set.seed(12345)


# Simulation Machine ------------------------------------------------------

charm <- simulationmachine::simulation_machine(
  num_claims = 50000,
  lob_distribution = c(0.25, 0.25, 0.30, 0.20),
  inflation = c(0.01, 0.01, 0.01, 0.01),
  sd_claim = 0.85,
  sd_recovery = 0.85
)

records <- simulationmachine::conjure(charm)

records_wide <- records |>
  tidyr::pivot_wider(
    names_from = development_year,
    values_from = c(paid_loss, claim_status_open),
    values_fill = list(paid_loss = 0)
  )

dplyr::glimpse(records)
dplyr::glimpse(records_wide)

num_claims <- records |>
  dplyr::distinct(claim_id) |>
  dplyr::count() |>
  dplyr::pull(1) |>
  as.numeric()

triangle <- records |>
  dplyr::filter(accident_year + development_year <= 1999) |>
  # aggregate to AY-dev cells
  dplyr::group_by(accident_year, development_year) |>
  dplyr::mutate(
    accident_year = accident_year + 21,
    development_year = dplyr::if_else(development_year == 1, 12, development_year * 12)
  ) |>
  dplyr::summarize(paid_loss = sum(paid_loss), .groups = "drop_last") |>
  dplyr::group_by(accident_year) |>
  # calculate cumulative losses
  dplyr::mutate(cumulative_paid_loss = cumsum(paid_loss)) |>
  dplyr::select(accident_year, development_year, cumulative_paid_loss) |>
  # reshape the data
  tidyr::pivot_wider(
    names_from = "development_year",
    values_from = "cumulative_paid_loss"
  )


# Simulate Policy Data ----------------------------------------------------

# -

tbl_policy <- imaginator::policies_simulate(
  n = 2,
  policy_years = c(2010:2022),
  exposure = 1,
  retention = 1,
  growth = 0,
  start_id = 1
)
