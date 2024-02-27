selected_cdfs <- tibble::tribble(
  ~Age,      ~Type,      ~Limit,     ~Factor,
  12L, "Reported", "Unlimited", 2.486915505,
  24L, "Reported", "Unlimited", 1.445881107,
  36L, "Reported", "Unlimited", 1.235795818,
  48L, "Reported", "Unlimited", 1.170261192,
  60L, "Reported", "Unlimited", 1.133974023,
  72L, "Reported", "Unlimited", 1.115076573,
  84L, "Reported", "Unlimited", 1.100330955,
  96L, "Reported", "Unlimited", 1.089111436,
  108L, "Reported", "Unlimited", 1.079537682,
  120L, "Reported", "Unlimited", 1.071318074,
  132L, "Reported", "Unlimited", 1.064242169,
  144L, "Reported", "Unlimited", 1.058102201,
  156L, "Reported", "Unlimited", 1.052746298,
  168L, "Reported", "Unlimited", 1.048008661,
  180L, "Reported", "Unlimited", 1.043781143,
  192L, "Reported", "Unlimited", 1.040019125,
  204L, "Reported", "Unlimited", 1.036248615
)

## Derive Decay Factors for Ages past Age 204

max_age <- max(selected_cdfs$Age)
min_decay_age <- max_age - (8 * 12)

decay_factor_logs <- selected_cdfs |>
  dplyr::mutate(
    Decay = log(.data$Factor) / log(dplyr::lag(.data$Factor, n = 1L, order_by = .data$Age)),
    Decay = ifelse(Age < min_decay_age, NA_real_, Decay)
  )

selected_decay <- mean(decay_factor_logs$Decay, na.rm = TRUE)

last_selected_cdf <- dplyr::filter(
  decay_factor_logs,
  .data$Age == max_age
) |>
  dplyr::pull(
    .data$Factor
  )

ages_past_max_selected <- seq(from = max_age + 12, to = (max_age + (12 * 6)), by = 12)

selected_decayed_factors <- c(
  last_selected_cdf ^ selected_decay,
  last_selected_cdf ^ selected_decay ^ 2,
  last_selected_cdf ^ selected_decay ^ 3,
  last_selected_cdf ^ selected_decay ^ 4,
  last_selected_cdf ^ selected_decay ^ 5,
  last_selected_cdf ^ selected_decay ^ 6
)

decayed_factors <- tibble::tibble(
  Age = ages_past_max_selected,
  Type = "Reported",
  Limit = "Unlimited",
  Factor = selected_decayed_factors
) |>
  dplyr::bind_rows(
    selected_cdfs
  ) |>
  dplyr::arrange(
    .data$Age
  )

# |>
#   dplyr::mutate(
#     Age_Exp = ifelse(
#       .data$Age > max_age,
#       (.data$Age - max_age) / 12,
#       NA_real_
#     ),
#     Factor = ifelse(
#       is.na(.data$Factor),
#       dplyr::lag(.data$Factor, n = .data$Age_Exp, order_by = .data$Age) ^ (selected_decay ^ .data$Age_Exp),
#       .data$Factor
#     )
#   )

