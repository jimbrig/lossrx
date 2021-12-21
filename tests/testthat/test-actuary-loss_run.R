test_that("loss_run conversion works", {
  trans <- claims_transactional
  test_df <- loss_run(val_date = Sys.Date(), claims_transactional)
  expect_s3_class(test_df, "tbl_df")
  expect_s3_class(test_df, "data.frame")
  expect_true(ncol(test_df) == 22)
  expect_true(nrow(test_df) == length(unique(trans$claim_num)))
})
