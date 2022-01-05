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

#' Get Common Columns
#'
#' Get common columns across two tables
#'
#' @param tables a list with two elements: x and y
#' @keywords internal
#' @return a list with two elements: x and y
#' @importFrom crayon yellow bold
#' @export
#' @rdname data-utils
get_common_columns <- function(tables) {
  x <- tables$x
  y <- tables$y

  not.in.x <- colnames(y)[!c(colnames(y) %in% colnames(x))]
  not.in.y <- colnames(x)[!c(colnames(x) %in% colnames(y))]

  if (length(not.in.x) > 0) {
    cat(crayon::yellow(paste0(
      "Column(s) '", paste(not.in.x, collapse = "', '"),
      "' are not in ", crayon::bold("LHS"),
      " so they have been removed from the comparison.\n"
    )))
  }
  if (length(not.in.y) > 0) {
    cat(crayon::yellow(paste0(
      "Column(s) '", paste(not.in.y, collapse = "', '"),
      "' are not in ", crayon::bold("RHS"),
      " so they have been removed from the comparison.\n"
    )))
  }

  common.columns <- colnames(x)[colnames(x) %in% colnames(y)]
  if (length(common.columns) == 0) {
    stop("Tables don't have common columns.", call. = FALSE)
  }

  x <- x[common.columns]
  y <- y[common.columns]

  tables <- list(x = x, y = y)
  return(tables)
}

#' Get Common Number of Rows
#'
#' Get common number of rows across two tables
#'
#' @param tables a list with two elements: x and y
#' @keywords internal
#' @return a list with two elements: x and y
#' @importFrom crayon yellow bold
#' @export
#' @rdname data-utils
get_common_nr_rows <- function(tables) {
  x <- tables$x
  y <- tables$y

  n1 <- nrow(x)
  n2 <- nrow(y)
  if (n1 > n2) {
    cat(crayon::yellow(paste0(
      crayon::bold("LHS"), " has more rows than ",
      crayon::bold("RHS"), ". The last ", n1 - n2,
      " row(s) of ", crayon::bold("LHS"),
      " have been removed.\n"
    )))
    x <- as.data.frame(x[1:n2, ])
  }

  if (n2 > n1) {
    cat(crayon::yellow(paste0(
      crayon::bold("RHS"), " has more rows than ",
      crayon::bold("LHS"), ". The last ", n2 - n1,
      " row(s) of ", crayon::bold("RHS"),
      " have been removed.\n"
    )))
    y <- as.data.frame(y[1:n1, ])
  }

  tables <- list(x = x, y = y)
  return(tables)
}

#' Get Common Types
#'
#' Get common types of columns across two tables
#'
#' @param tables a list with two elements: x and y
#' @keywords internal
#' @return a list with two elements: x and y
#' @importFrom crayon yellow bold
#' @importFrom dplyr left_join rename mutate
#' @importFrom purrr pmap_chr
#' @export
#' @rdname data-utils
get_common_types <- function(tables) {
  x <- tables$x
  y <- tables$y

  util.types <- data.frame(
    ColType = c("logical", "integer", "double", "character"),
    Power = 1:4,
    stringsAsFactors = FALSE
  )

  col.types.x <- c()
  col.types.y <- c()
  for (i in 1:ncol(x)) col.types.x[i] <- typeof(x[, i])
  for (i in 1:ncol(y)) col.types.y[i] <- typeof(y[, i])

  col.types <- data.frame(
    Column = colnames(x),
    ColTypeX = col.types.x,
    ColTypeY = col.types.y,
    stringsAsFactors = FALSE
  )

  types.tally <- col.types %>%
    dplyr::left_join(util.types, by = c("ColTypeX" = "ColType")) %>%
    dplyr::rename(PowerX = Power) %>%
    dplyr::left_join(util.types, by = c("ColTypeY" = "ColType")) %>%
    dplyr::rename(PowerY = Power) %>%
    dplyr::mutate(Same = (ColTypeX == ColTypeY)) %>%
    dplyr::mutate(
      StrongerType =
        purrr::pmap_chr(
          list(PowerX, PowerY, ColTypeX, ColTypeY),
          function(p1, p2, ct1, ct2) if (p1 > p2) ct1 else ct2
        )
    )

  for (r in 1:nrow(types.tally)) {
    if (types.tally[r, "Same"] == FALSE) {
      row <- types.tally[r, ]
      if (row$PowerY > row$PowerX) {
        cat(crayon::yellow(paste0(
          "Column '", row$Column, "' in ", crayon::bold("LHS"),
          " has been coerced from ", row$ColTypeX,
          " to ", row$StrongerType, ".\n"
        )))
        x[, row$Column] <- as(x[, row$Column], type = row$StrongerType)
      } else {
        cat(crayon::yellow(paste0(
          "Column '", row$Column, "' in ", crayon::bold("RHS"),
          " has been coerced from ", row$ColTypeY,
          " to ", row$StrongerType, ".\n"
        )))
        y[, row$column] <- as(y[, row$Column], type = row$StrongerType)
      }
    }
  }

  tables <- list(x = x, y = y)
  return(tables)
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
