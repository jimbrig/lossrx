#' create_triangle <- function(tri_dat,
#'                             origin = NULL,
#'                             age = NULL,
#'                             val = NULL,
#'                             origin_label = "AYE",
#'                             val_type = c("rept", "paid", "cnt"),
#'                             age_unit = c("month", "year", "qtr")) {
#'
#'   tri_dat_new <- tibble::new_tibble(tri_dat, class = "tri")
#'
#'   val_type <- ifelse(is.null(val_type), "rept", val_type)
#'
#'   class(tri_dat_new$origin) <- c(origin_label, class(tri_dat_new$origin))
#'   class(tri_dat_new$age) <- c(age_unit, class(tri_dat_new$age))
#'   class(tri_dat_new$value) <- c(val_type, class(tri_dat_new$value))
#'
#'
#'
#' }
#'
#' #' Triangle Constructor and Validator
#' #'
#' #' @description
#' #' Creates and validates a subclass of a typical actuarial triangle structure.
#' #'
#' #' `new_triangle()` creates a new object with class `tri` as a subclass of
#' #' `tibble`, `tbl_df`, `tbl`, and `data.frame` (respectively).
#' #' See [tibble::new_tibble()] and its `class` argument for implementation details.
#' #'
#' #' @param origin a vector of incremental numerics representing the "Origin" periods for the
#' #'   triangle (i.e. Accident Year). These values will represent the left-hand side
#' #'   column in a typical actuarial triangle, sorted from smallest to largest.
#' #' @param age a vector of incremental numerics representing the maturity "ages"
#' #'   for a typical actuarial triangle (i.e. ages in months since start of "origin").
#' #'   These values will represent the top row above a typical actuarial trianlge,
#' #'   sorted from smallest to largest and with evenly distributed increments between
#' #'   values (i.e. 12 month increments).
#' #' @param value a vector of values representing the body of the trianlge; what
#' #'   the values represent. Reported, Paid, Counts, Case Reserves, Incremental Paid, etc.
#' #'   are common values used in actuarial triangles.
#' #'
#' #' @return an [tibble::tibble()] or [data.frame()] object with added class of `tri`
#' #'
#' #' @export
#' #'
#' #' @examples
#' #' mytri <- new_tri(2020, 12, 10000)
#' #' class(mytri)
#' #' str(mytri)
#' #' validate_tri(mytri)
#' #'
#' #' mytri2 <- new_tri(c(2020:2021), c(12,24), c(10000, 11000))
#' #' class(mytri2)
#' #' str(mytri2)
#' #' validate_tri(mytri2)
#' new_tri <- function(origin = numeric(), age = numeric(), value = numeric()) {
#'
#'   stopifnot(is.numeric(origin), is.numeric(age), is.numeric(value))
#'
#'   hold <- expand.grid(c(2020:2021), c(12, 24), KEEP.OUT.ATTRS = FALSE, stringsAsFactors = FALSE) |>
#'     tibble::as_tibble() |>
#'     setNames(c("origin", "age")) |>
#'     dplyr::arrange(origin, age)
#'
#'   out <- tibble::new_tibble(list(origin = origin, age = age, value = value), class = "tri") |>
#'     dplyr::right_join(hold) |>
#'     tidyr::pivot_wider(names_from = age, values_from = value)
#'
#'   stopifnot(inherits(out, "tri"))
#'
#'   out
#'
#' }
#'
#' #' @description
#' #' `validate_tri()` checks a `tri()` object for internal consistency.
#' #'
#' #' @param tri `tri()` object
#' #' @rdname new_tri
#' #' @export
#' validate_tri <- function(tri) {
#'   stopifnot(nrow(tri) > 0, ncol(tri) >= 3)
#'   tri
#' }
#'
#'
#'
#'
#' #' #' `tri` - Actuarial Triangle
#' #' #'
#' #' #' Loss Development Triangle Structure
#' #' #'
#' #' #' @param origin Numeric/Character - Represents the 'origin' or period who's
#' #' #'   beginning is the start of a period (i.e. Accident Year).
#' #' #' @param age Numeric - Age of Development in Months
#' #' #' @param value Numeric - Value representing Paid Dollars,
#' #' #'   Incurred/Reported Dollars, or Claim Counts
#' #' #'
#' #' #' @return a [tibble::tibble()] structure with class "tri"
#' #' #' @export
#' #' #'
#' #' #' @examples
#' #' #' tri(2020, 12, 50000)
#' #' tri <- structure(tibble::tibble())
#' #' tri <- function(..., origin, ) {
#' #'
#' #' }
#' #' tri.default <- function(origin, age, value) {
#' #'   tib <- tibble::tibble(origin = origin, age = age, value = value)
#' #'   structure(tib, class = c("tri", class(tib)))
#' #' }
#'
#'
#'
#' # derive_triangles <- function(loss_dat,
#' #                              type = c("paid", "reported", "case", "n_claims"),
#' #                              limit = NULL) {
#' #
#' #   agg_dat <- loss_dat %>% aggregate_loss_data(limit = limit)
#' #
#' #   tri_dat <- devtri::dev_tri(
#' #     origin = agg_dat$accident_year,
#' #     age = agg_dat$devt,
#' #     value = agg_dat[[type]]
#' #   )
#' #
#' #   tri <- tri_dat %>%
#' #     devtri::spread_tri() %>%
#' #     dplyr::rename(AYE = origin)
#' #
#' #   if (type == "case") {
#' #     return(list(
#' #       "aggregate_data" = agg_dat,
#' #       "triangle_data" = tri_dat,
#' #       "triangle" = tri
#' #     ))
#' #   }
#' #
#' #   ata_dat <- tri_dat %>%
#' #     devtri::ata_tri(loss_dat) %>%
#' #     dplyr::filter(!is.na(value))
#' #
#' #   ata_tri <- ata_dat %>%
#' #     devtri::spread_tri() %>%
#' #     dplyr::rename(AYE = origin) %>%
#' #     dplyr::mutate(AYE = as.character(AYE))
#' #
#' #   # ata_tri <- triangle_data[[input$type]]$age_to_age_triangle %>%
#' #   #   mutate(AYE = as.character(AYE))
#' #
#' #   ldf_avg <- devtri::idf(devtri::ldf_avg(tri_dat)$idfs)
#' #
#' #   ldf_avg_wtd <- devtri::idf(devtri::ldf_avg_wtd(tri_dat)$idfs)
#' #
#' #   sel <- ldf_avg_wtd
#' #
#' #   cdf <- devtri::idf2cdf(sel)
#' #
#' #   params <- list(
#' #     "Straight Average:" = ldf_avg,
#' #     "Weighted Average:" = ldf_avg_wtd,
#' #     "Selected:" = sel,
#' #     "CDF:" = cdf
#' #   )
#' #
#' #   hold <-
#' #     purrr::map2_dfr(params, names(params), function(dat, type_) {
#' #       dat %>%
#' #         tidyr::pivot_wider(names_from = age, values_from = names(dat)[2]) %>%
#' #         rlang::set_names(names(ata_tri)) %>%
#' #         dplyr::mutate(AYE = type_)
#' #     })
#' #
#' #   list(
#' #     "aggregate_data" = agg_dat,
#' #     "triangle_data" = tri_dat,
#' #     "triangle" = tri,
#' #     "age_to_age_data" = ata_dat,
#' #     "age_to_age_triangle" = ata_tri,
#' #     "averages" = hold
#' #   )
#' #
#' # }
#'
#'
#'
#' #' Aggregate Loss data
#' #'
#' #' @param claim_dat claims data
#' #' @param limit optional limit
#' #'
#' #' @return df
#' #'
#' #' @importFrom dplyr mutate group_by summarise n ungroup
#' aggregate_loss_data <- function(claim_dat, limit = NA) {
#'   if (!is.na(limit)) {
#'     claim_dat <- claim_dat %>%
#'       dplyr::mutate(
#'         paid = pmin(limit, .data$paid),
#'         reported = pmin(limit, .data$reported),
#'         case = reported - paid
#'       )
#'   }
#'
#'   claim_dat %>%
#'     dplyr::group_by(accident_year, devt) %>%
#'     dplyr::summarise(
#'       paid = sum(.data$paid, na.rm = TRUE),
#'       reported = sum(.data$reported, na.rm = TRUE),
#'       n_claims = dplyr::n()
#'     ) %>%
#'     dplyr::ungroup() %>%
#'     dplyr::mutate(case = reported - paid)
#' }
