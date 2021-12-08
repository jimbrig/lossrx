#' Open pkgdown site of the package
#'
#' @importFrom utils browseURL
#'
#' @export
#'
#' @examples
#' open_pkgdown()
open_pkgdown <- function() {
      guide_path <- system.file('docs/index.html', package = 'lossrx')
      if (guide_path == "") {
        stop('There is no pkgdown site in ', 'docs/index.html')
      }

  browseURL(paste0('file://', guide_path))
}
