interpolate_cdfs <- function(selected_cdfs, selected_ages, step_age = 1, min_age = 1, max_age = max(selected_ages)) {

  selecteds <- data.frame(age = selected_ages, cdf = selected_cdfs)

  df <- data.frame(age = c(min_age:max_age)) |> dplyr::left_join(selecteds, by = "age")

  df_lower <- dplyr::filter(df, age < min(selected_ages)) |>
    dplyr::mutate(persistency = 1 / (1 / min(selected_ages) * age)) |>
    dplyr::mutate(cdf = persistency * selected_cdfs[[1]])

  df_updated <- dplyr::bind_rows(
    dplyr::select(df_lower, age, cdf),
    dplyr::filter(df, age >= min(selected_ages))
  )

  interpfxn <- splinefun(x = df_updated$age, y = df_updated$cdf, method = "fmm")

  df_updated_2 <- df_updated %>% dplyr::mutate(cdf = ifelse(is.na(cdf), interpfxn(.data$age, deriv = 0), cdf))

  interpfxn.linear <- approxfun(x = df_updated_2$age, y = df_updated_2$cdf, method = "linear")

  first_age_upper <- min(dplyr::filter(df_updated_2, cdf < 1)$age) - step_age

  df_upper <- dplyr::filter(df_updated_2, age >= first_age_upper)

  df_upper_new <- data.frame(age = c(min(df_upper$age), max(df_upper$age))) |>
    dplyr::left_join(df_upper, by = "age")

  new_interpfxn <- splinefun(x = df_upper_new$age, y = df_upper_new$cdf, method = "fmm")

  df_upper_adj <- dplyr::mutate(df_upper, cdf = new_interpfxn(.data$age))

  out <- dplyr::bind_rows(
    dplyr::filter(df_updated_2, !(.data$age %in% df_upper_adj$age)),
    df_upper_adj
  )

  out

}


selected_paid_cdfs <- c(3.579, 2.866, 2.489, 2.121, 1.876, 1.543, 1.222, 1.150, 1.109, 1.005, 1.0025)
selected_incurred_cdfs <- c(2.5, 2.1, 1.5, 1.32, 1.11, 1, 1, 1, 1, 1, 1)
selected_ages <- seq(from = 12, to = (length(selected_cdfs) * 12), by = 12)


interp_paid <- interpolate_cdfs(selected_cdfs = selected_paid_cdfs, selected_ages = selected_ages)
interp_incurred <- interpolate_cdfs(selected_cdfs = selected_incurred_cdfs, selected_ages = selected_ages)

interp <- dplyr::left_join(dplyr::rename(interp_paid, paid_cdf = cdf), dplyr::rename(interp_incurred, rept_cdf = cdf), by = "age") |>
  dplyr::mutate(
    pct_paid = 1 / paid_cdf,
    pct_rept = 1 / rept_cdf
  )




# interpolate <- function(cdfs = double(), ages = integer(), ...) {
#
#   cdfs <- data.frame(cdf = cdfs, age = ages)
#   all_cdfs <- data.frame(age = c(1:max(ages) + (12 * 5)), cdf = NA_double_)
#   less_than_first <- cdfs[cdfs$age <= min(ages)]
#   greater_than_last <- cdfs[]
#
#   UseMethod("interpolate")
# }
#
# interpolate.default <- function(cdfs, ages, age_out, ...) { interpolate.linear(cdfs, ages, age_out, ...) }
#
# interpolate.linear <- function(cdfs, ages, age_out, ...) {
#   approx(ages, cdfs, xout = age_out)$y
# }
#
# interpolate(ldfs$cdf, ldfs$age, 33)
# interpolate(ldfs$cdf, ldfs$age, 37)
# interpolate(ldfs$cdf, ldfs$age, 55)
#
# interpolate.exponential <- function(cdfs, ages, age_out, ...) {
#   spline(ages, cdfs, xout = age_out, method = "fmm")
# }
#
# interpolate.exponential(ldfs$cdf, ldfs$age, 43, "fmm")
# interpolate.exponential(ldfs$cdf, ldfs$age, 43, "natural")
# interpolate.exponential(ldfs$cdf, ldfs$age, 43, "periodic")
# interpolate.exponential(ldfs$cdf, ldfs$age, 43, "monoH.FC")
# interpolate.exponential(ldfs$cdf, ldfs$age, 43, "hyman")
#
#
# interpolate <- function(ages, cdfs, interp_age, ...) {
#
#   ages <- as.numeric(ages)
#   cdfs <- as.numeric(cdfs)
#
#   stopifnot(is.numeric(interp_age) && interp_age > 0)
#
#   UseMethod()
#   out <- approx(x = ldfs$age, y = ldfs$cdf, xout = 13)
#
# }
#
# new_cdf_array <- function(vals = double(), ages = integer(), age_units = c("months", "quarters", "years")) {
#   # stopifnot(is.double(vals), is.integer(ages), length(vals) == length(ages))
#   age_units <- match.arg(age_units)
#   out <- c(vals)
#   names(out) <- as.character(ages)
#   structure(out, class = "cdf_array", age_units = age_units)
# }
#
#
# new_cdf_array(c(2.5, 1.5, 1.1), c(12, 24, 36), "months")
#
# cdf_array  <- function(factors = double(), ages = integer(), age_units = "months") {
#   x <- as.double(factors)
#   new_cdf_array(x, ages, age_units = age_units)
# }
#
#
# cdf_array(c(2.5, 1.5, 1.1), c(12, 24, 36))
#
#
# interpolate <- function(cdf_array, age_out) {
#   UseMethod("interpolate")
# }
#
# interpolate.linear <-
#
#
# cdfs <- cdf_array(new_cdf_array(c(2.8, 1.5, 1.1)), "months")
#
#                   class(cdfs)
#
#
# make_cdf_class <- function(vals, ages) {
#   structure(list(ages = NA_integer_, cdfs = NA_complex_), class = "cdf")
# }
#
#
#
#
# cdfs <-
#
# print.cdfs <- function(x, ...) {
#
#
#   with(x, )
# }
#
# ChainLadder:::print.triangle
