test_that("pull_unique works", {
  df <- data.frame(let = rep(letters, 2), num = rep(c(1:26), 2))
  expect_equal(pull_unique(df, 1), letters)
})
