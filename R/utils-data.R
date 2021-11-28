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
pull_unique <- function(df, var){
  df[[var]] |> unique() |> sort()
}
