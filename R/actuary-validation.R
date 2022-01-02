#' Actuarial Validation Functions
#'
#' @description
#' Suite of functions for validating actuarial related data.
NULL

#' Validate Paid Case Incurred
#'
#' @description
#' Given a supplied lossrun, validates all calculated or inter-dependant fields
#' have logical and correct values. This includes checks such as:
#'
#' - Paid + Case = Incurred
#' - Flag any negative Paid
#' -
