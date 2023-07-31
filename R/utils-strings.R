#' Extract numbers from a string
#'
#' @param string String to pull numbers from
#'
#' @return String of numbers
#' @export
#' @importFrom stringr str_extract
extract_num <- function(string) {
  stringr::str_extract(string, "\\d+") # "\\-*\\d+\\.*\\d*")
}

#' To Proper
#'
#' @param string string to manipulate on
#' @param replace_underscores Logical: if \code{TRUE} replaces all underscores
#'   with specified \code{underscore_replacement} argument's value.
#' @param underscore_replacement Character: if argument \code{replace_underscores}
#'  equals \code{TRUE}, will replace all "_"'s with specified string.
#' @param return_as How should the string be returned? Options are:
#'   \itemize{
#'   \item{"titlecase"}: Applies \code{stringr::str_to_title}.
#'   \item{"uppercase"}: Applies \code{toupper}.
#'   \item{"lowercase"}: Applied \code{tolower}.
#'   \item{"asis"}: No manipulation. Returns as is.
#'   }
#'
#' @param uppers Abbreviations to keep upper-case.

#' @seealso \code{\link[stringr]{str_replace}}.
#'
#' @return "Proper" string
#' @export
#'
#' @examples
#' s <- "variable_a is awesome"
#' toproper(s)
#'
#' @importFrom stringr str_replace_all str_to_title
toproper <- function(string,
                     replace_underscores = TRUE,
                     underscore_replacement = " ",
                     return_as = c("titlecase", "uppercase", "lowercase", "asis"),
                     uppers = c("Tpa")) {
  return_as <- match.arg(return_as, several.ok = FALSE)

  if (replace_underscores) {
    string <- stringr::str_replace_all(string, pattern = "_", replacement = underscore_replacement)
  }

  if (return_as == "asis") {
    return(string)
  }

  hold <- switch(return_as,
    titlecase = stringr::str_to_title(string),
    uppercase = toupper(string),
    lowercase = tolower(string)
  )

  stringr::str_replace_all(hold, uppers, toupper(uppers))
}
