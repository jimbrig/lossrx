#' `interp` - Actuarial Interpolation
#'
#' Interpolate Cumulative Loss Development Factors (CDFs).
#'
#'
#' This generic function comes with three possible `method`s:
#'  1. Linear Interpolation
#'  2. Exponential Interpolation
#'  3. Double Exponential Interpolation
#'
#' @details
#' Actuaries often have to *interpolate* values in-between the selected Loss
#' Development Factors (LDFs) / Cumulative Loss Development Factors (CDFs)
#' in order to derive development factors at a variety of possible ages of
#' maturity, outside the scope of the selected factors by the actuary.
#'
#' For example, an actuary will select factors by maturity or development age
#' in months using actuarial triangles. Due to the fact the actuarial selections
#' are limited to the maturities present in the triangle (i.e. ages 12, 24, etc.),
#' the factors for ages before, after, and in-between the selection ages must be
#' *interpolated*.
#'
#' A comprehensive approach to deriving the interpolated values would follow a
#' pattern similar to the following:
#'
#' - For ages of maturity `<= First Selected Age of Maturity` (i.e. `<= 12`),
#'   factors are derived using *persistencies*. A persistency is simply a
#'   percentage value representing the percent paid/reported at a given age
#'   compared to the age's ceiling and floor. For example, a persistency as of
#'   age 3 would represent the percent paid/reported at 3 months of development
#'   out of the total percent paid/reported at 12 months of development. The
#'   persistency as of age 15 would represent the percent paid/reported at age
#'   15 compared to the total percent paid/reported between ages 12 and 24.
#'
#' - For ages of maturity `Selected Age of Maturity Floor <= x <= Selected Age of Maturity Ceiling`,
#'   i.e. *in-between* ages, the factors are derived using *double-exponential*
#'   interpolation using the selections at the floor and ceiling ages.
#'
#' - For ages of maturity `>= Last Selected Age of Maturity` (i.e. `>= 106`),
#'   a *decay factor approach* is used to *decay* the final selected factor
#'   across the ages beyond that final age.
#'
#'
#' @param new_age integer - value of the new age whose CDF is to be interpolated
#' @param cdf_array numeric vector of CDFs (usually representative of the selected factors)
#' @param age_array numeric vector of ages corresponding to the supplied `cdf_array`
#' @param cutoff the largest possible age, after which, no interpolation is performed
#' @param method integer - must be 1, 2, or 3 where 1 represents linear, 2 represents exponential,
#'   and 3 represents double exponential. Defaults to 3, but falls back onto 1 if necessary.
#'
#' @return derived numeric value for the supplied `new_age`'s CDF
#' @export
#'
#' @name interp
#'
#' @examples
#' cdfs <- c(3.579, 2.866, 2.489, 2.121, 1.876, 1.543, 1.222, 1.150, 1.109, 1.005, 1.0025)
#' ages <- seq(from = 12, to = (length(cdfs) * 12), by = 12)
#'
#' interp(14, cdfs, ages)
#' interp(12, cdfs, ages) == cdfs[[1]]
#' interp(27, cdfs, ages, method = 2)
interp <- function(new_age, cdf_array, age_array, cutoff = 450, method = 3) {
  stopifnot(
    is.numeric(new_age),
    is.numeric(cdf_array),
    is.numeric(age_array),
    length(cdf_array) == length(age_array),
    length(cdf_array[cdf_array < 0]) == 0,
    length(cdf_array[age_array < 0]) == 0,
    is.numeric(cutoff),
    is.numeric(method),
    method %in% c(1:3),
    new_age <= cutoff
  )

  age_high <- min(age_array[age_array >= new_age])
  age_low <- max(age_array[age_array <= new_age])
  cdf_high <- cdf_array[match(age_high, age_array)]
  cdf_low <- cdf_array[match(age_low, age_array)]

  if (any(age_high == age_low, cdf_high == cdf_low)) {
    return(cdf_high)
  }

  if (any(method == 1, new_age < min(age_array), cdf_high < 1, cdf_low < 1)) {
    out <- interp.linear(new_age, age_high, age_low, cdf_high, cdf_low)
    return(out)
  }

  if (method == 2) {
    out <- interp.exp(new_age, age_high, age_low, cdf_high, cdf_low)
    return(out)
  }

  out <- interp.dblexp(new_age, age_high, age_low, cdf_high, cdf_low)
  return(out)
}



#' @describeIn interp Double Exponential Interpolation
#' @param age_low,age_high Low and High ages
#' @param cdf_low,cdf_high Low and High CDFs
interp.dblexp <- function(new_age, age_high, age_low, cdf_high, cdf_low) {
  new_cdf <- exp(exp(((age_high - new_age) * log(log(1 / (1 / cdf_low))) +
    (new_age - age_low) * log(log(1 / (1 / cdf_high)))) /
    (age_high - age_low)))

  new_cdf
}

#' @describeIn interp Exponential Interpolation
#' @param age_low,age_high Low and High ages
#' @param cdf_low,cdf_high Low and High CDFs
interp.exp <- function(new_age, age_high, age_low, cdf_high, cdf_low) {
  new_cdf <- 1 / (1 - exp(((age_high - new_age) * log(1 - (1 / cdf_low)) +
    (new_age - age_low) * log(1 - (1 / cdf_high))) /
    (age_high - age_low)))
  new_cdf
}

#' @describeIn interp Linear Interpolation
#' @param age_low,age_high Low and High ages
#' @param cdf_low,cdf_high Low and High CDFs
interp.linear <- function(new_age, age_high, age_low, cdf_high, cdf_low) {
  new_cdf <- 1 / (((age_high - new_age) * (1 / cdf_low) + (new_age - age_low) * (1 / cdf_high)) /
    (age_high - age_low))

  new_cdf
}


# \section{Formulas}{
#  For Linear Interpolation the formula is as follows:
#    \if{html}{\figure{dblexp.svg}{options: width=100 alt="Double Exponential Interpolation"}}
#  \if{latex}{\figure{dblexp.svg}{options: width=0.5in}}
# }
