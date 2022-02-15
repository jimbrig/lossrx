library(dplyr)

num_clms <- 10
t <- simulate_claims(n = num_clms)
claim_count <- length(unique(t$claim_num))

test_that("claims simulation produces correct number of unique claims", {
  expect_equal(claim_count, num_clms)
})

test_that("claims simulation produces logical closures", {
  # test that case reserves zero out on closure
  clms <- t |>
    group_by(claim_num) |>
    mutate(prior_status = lag(status, order_by = transaction_date),
           prior_status = coalesce(prior_status, "NEW"),
           status_chg = paste0(prior_status, "->", status))

  closures <- clms |> filter(status_chg == "Open->Closed")
  expect_true(all(closures$case == 0))
  expect_true(all(closures$status == "Closed"))
})
