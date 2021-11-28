test_that("end of month is correct (i.e. 30 versus 31 and 28 for February)", {
  expect_equal(end_of_month(as.Date("2019-02-05")), as.Date("2019-02-28"))
})

test_that("start of month is correct", {
  expect_equal(start_of_month(as.Date("2015-07-04")), as.Date("2015-07-01"))
})

test_that("converts strings to dates properly", {
  expect_equal(end_of_month("2019-02-05"), as.Date("2019-02-28"))
  expect_equal(start_of_month("2015-07-04"), as.Date("2015-07-01"))

  expect_equal(end_of_month("2019/02/05"), as.Date("2019-02-28"))
  expect_equal(start_of_month("2015/07/04"), as.Date("2015-07-01"))

  expect_equal(end_of_month("February 5, 2019"), as.Date("2019-02-28"))
  expect_equal(start_of_month("July 4 2015"), as.Date("2015-07-01"))
})
