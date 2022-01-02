cdfs <- c(3.579, 2.866, 2.489, 2.121, 1.876, 1.543, 1.222, 1.150, 1.109, 1.005, 1.0025)
ages <- seq(from = 12, to = (length(cdfs) * 12), by = 12)

test_that("interpolation function returns correct values", {
  expect_equal(interp(12, cdfs, ages), cdfs[[1]])
  expect_equal(interp(24, cdfs, ages), cdfs[[2]])
})

test_that("interpolation function throws error if negative", {
  cdfs_wrong <- cdfs
  cdfs_wrong[[1]] <- -1
  expect_error(interp(14, cdfs_wrong, ages))
})
