library(simulationmachine)
library(dplyr)
library(tidyr)

charm <- simulation_machine(
  num_claims = 50000,
  lob_distribution = c(0.25, 0.25, 0.30, 0.20),
  inflation = c(0.01, 0.01, 0.01, 0.01),
  sd_claim = 0.85,
  sd_recovery = 0.85
)

charm

records <- conjure(charm, seed = 100)
glimpse(records)

num_claims <- records %>%
  distinct(claim_id) %>%
  count() |>
  pull(1)

records_wide <- records %>%
  tidyr::pivot_wider(
    names_from = development_year,
    values_from = c(paid_loss, claim_status_open),
    values_fill = list(paid_loss = 0)
  )

glimpse(records_wide)

triangle <- records %>%
  filter(accident_year + development_year <= 2016) %>%
  # aggregate to AY-dev cells
  group_by(accident_year, development_year) %>%
  summarize(paid_loss = sum(paid_loss)) %>%
  group_by(accident_year) %>%
  # calculate cumulative losses
  mutate(cumulative_paid_loss = cumsum(paid_loss)) %>%
  select(accident_year, development_year, cumulative_paid_loss) %>%
  # reshape the data
  pivot_wider(
    names_from = "development_year",
    values_from = "cumulative_paid_loss"
  )
