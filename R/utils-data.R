#' Data Manipulation Utilities
#'
#' @name data-utils
#' @family Data Utilities
#' @keywords data, utility, munge, cleanse
#'
#' @return
#'   - `pull_unique` returns a character vector of unique, sorted values from specified column
#'
#' @examples
#' df <- data.frame(let = rep(letters, 2), num = rep(c(1:26), 2))
#' pull_unique(df, 1)
#' pull_unique(df, "num")
NULL

#' Pull Unique Values from a dataframe
#'
#' @param df a provided [data.frame()]
#' @param var character/numeric - quoted named of a variable from `df` or its
#'   numerical index.
#'
#' @rdname data-utils
#' @export
pull_unique <- function(df, var) {
  df[[var]] |>
    unique() |>
    sort()
}

#' Coalesce Join
#'
#' @param x x
#' @param y y
#' @param by by
#' @param suffix suffix
#' @param join join type
#' @param ... passed to dplyr join function
#'
#' @return a [tibble][tibble::tibble-package]
#' @export
#' @importFrom dplyr union coalesce bind_cols
#' @importFrom purrr map_dfc
#' @importFrom dplyr union coalesce bind_cols
#' @importFrom purrr map_dfc
coalesce_join <- function(x,
                          y,
                          by = NULL,
                          suffix = c(".x", ".y"),
                          join = dplyr::full_join,
                          ...) {

  joined <- join(y, x, by = by, suffix = suffix, ...)

  # names of desired output
  cols <- dplyr::union(names(x), names(y))

  to_coalesce <- names(joined)[!names(joined) %in% cols]

  suffix_used <- suffix[ifelse(endsWith(to_coalesce, suffix[1]), 1, 2)]

  # remove suffixes and deduplicate
  to_coalesce <- unique(
    substr(
      to_coalesce,
      1,
      nchar(to_coalesce) - nchar(suffix_used)
    )
  )

  coalesced <- purrr::map_dfc(
    to_coalesce, ~ dplyr::coalesce(joined[[paste0(.x, suffix[1])]],
                                   joined[[paste0(.x, suffix[2])]])
  )

  names(coalesced) <- to_coalesce

  dplyr::bind_cols(joined, coalesced)[cols]

}


#' Document Datasets
#'
#' Creates skeleton to document datasets via `roxygen2`.
#'
#' @param obj object to document
#' @param title Title
#' @param description Description
#' @param write_to_file Logical
#' @param ... N/A
#'
#' @return silently returns the doc_string
#' @export
#'
#' @examples
#' library(lossrx)
#' data(losses)
#' string <- doc_data(losses, "Loss Data", "Claims Data", FALSE)
#' cat(string)
#' @importFrom usethis use_r
doc_data <- function(obj,
                     title = deparse(substitute(obj)),
                     description = "DATASET_DESCRIPTION",
                     write_to_file = TRUE,
                     ...) {

  vartype <- vapply(obj, typeof, FUN.VALUE = character(1))

  items <- paste0("#'   \\item{\\code{",
                  names(vartype),
                  "}}{",
                  vartype,
                  ". DESCRIPTION.}", collapse = "\n")

  out <- paste0(
    "\n#' ",
    title,
    "\n#'\n#' ",
    description,
    "\n#'\n#' @format A `data.frame` with ",
    nrow(obj),
    " rows and ",
    length(vartype),
    " variables:\n#' \\describe{\n",
    items,
    "\n#' }\n\"",
    title,
    "\""
  )

  if (!write_to_file) return(out)
  write(out, file = "R/data.R", append = TRUE, sep = "\n")
  usethis::use_r("data.R")

  invisible(out)

}
