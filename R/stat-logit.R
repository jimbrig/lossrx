#' logit
#'
#' The `logit` function in mathematics is the `quantile` associated with the standard
#' [logistic distribution](https://en.wikipedia.org/wiki/Logistic_distribution).
#'
#' The `logit` is used widely as a method of transforming data for modelling purposes.
#'
#' @param p probability, where 0 < *p* < 1.
#'
#' @return Log of p/(1-p)
#' @export
#'
#' @examples
#' logit(.25)
logit <- function(p) {

  stopifnot(
    length(p[p < 0]) == 0,
    length(p[p > 1]) == 0
  )

  log(p / (1 - p))

}

#' dnorm_logit
#'
#' Lognormal Density Function
#'
#' @param p probability at which to evaluate the density function
#' @param mean_logit Mean of logarithmic values
#' @param sd_logit Standard Deviation of logarithmic values.
#'
#' @return z-value representing output of a given value of X
#' @export
#'
#' @examples
#' dnorm_logit()
dnorm_logit <- function(p, mean_logit, sd_logit){

  z <- 1 / (sd_logit * sqrt(2 * pi)) * 1 / (p * (1 - p)) * exp(-(logit(p) - mean_logit)^2 / (2 * sd_logit^2))

  return(z)

}
