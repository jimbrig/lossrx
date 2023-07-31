#' Date Utility Functions
#'
#' @description
#' A set of helper functions for dealing with dates in a typical actuarial
#' analysis context.
#'
#' @name dates
#' @family Date Utilities
#' @keywords dates
#'
#' @param date character or date representation of a date.
#' @param string string to extract a date from
#'
#' @return
#'  - `end_of_month` returns last day of the month given.
#'  - `start_of_month` returns the first day of the month given.
#'  - `extract_date` returns a date object extracted from the provided string.
#'
#' @seealso [as.Date()], [lubridate::ceiling_date()], [lubridate::floor_date()],
#'   [flipTime::AsDate()]
#'
#' @examples
#' # character input
#' start_of_month("2020-08-13")
#' end_of_month("2017-10-20")
#'
#' # can handle human-readable dates also
#' start_of_month("July 7, 1999")
#' end_of_month("February 5, 2019")
#'
#' # date input
#' start_of_month(as.Date("2020-08-13"))
#' end_of_month(as.Date("2020-10-20"))
NULL

#' End of Month
#'
#' @export
#' @rdname dates
#' @importFrom lubridate is.Date ceiling_date
#' @importFrom flipTime AsDate
end_of_month <- function(date) {
  if (!lubridate::is.Date(date)) date <- flipTime::AsDate(date)
  lubridate::ceiling_date(date, unit = "month") - 1
}


#' Beginning of Month
#'
#' @export
#' @rdname dates
#' @importFrom lubridate is.Date
#' @importFrom flipTime AsDate
start_of_month <- function(date) {
  if (!lubridate::is.Date(date)) date <- flipTime::AsDate(date)
  as.Date(format(date, "%Y-%m-01"))
}

#' Extract Date from String
#'
#' @export
#' @rdname dates
#' @importFrom lubridate mdy
#' @importFrom stringr str_extract_all
extract_date <- function(string) {
  paste0(
    unlist(
      stringr::str_extract_all(
        string,
        "[0-9]{1,2}[-./][0-9]{1,2}[-./][0-9]{2,4}"
      ),
      recursive = TRUE
    ),
    collapse = ""
  ) |>
    lubridate::mdy() |>
    as.character()
}

#' Elapsed Months
#'
#' Derive the number of months elapsed between two dates.
#'
#' @param end_date end date
#' @param start_date start date
#'
#' @rdname dates
#'
#' @return numeric
#' @export
elapsed_months <- function(end_date, start_date) {
  ed <- as.POSIXlt(end_date)
  sd <- as.POSIXlt(start_date)
  12 * (ed$year - sd$year) + (ed$mon - sd$mon)
}
