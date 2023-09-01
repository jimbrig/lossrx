#' Create Table
#'
#' Creates a database table given a connection, table name, and:
#'  - SQL file specifying the table's schema
#'  - CSV file to seed the table's values
#'
#' @param conn database connection
#' @param tbl_name character string representing table name
#' @param csv_path base path (excluding file) to the CSV file
#' @param sql_path base path (excluding file) to the SQL file
#' @param drop_if_exists Should the table be dropped (with CASCADE) if it already exists?
#'
#' @note
#' It is assumed that the `tbl_name` mirrors both the basename of the CSV file
#' and the SQL file (excluding extensions).
#'
#' @return the created database table returned as an R [data.frame()].
#' @export
#'
#' @importFrom dbx dbxExecute dbxInsert
#' @importFrom dplyr collect tbl
#' @importFrom readr read_file read_csv
#' @importFrom tibble as_tibble
create_tbl <- function(conn, tbl_name, csv_path = "data-raw/database/CSV", sql_path = "data-raw/database/SQL", drop_if_exists = TRUE) {
  sql_path <- file.path(sql_path, paste0(tbl_name, ".sql"))
  csv_path <- file.path(csv_path, paste0(tbl_name, ".csv"))
  sql <- readr::read_file(sql_path)
  csv <- readr::read_csv(csv_path) |> tibble::as_tibble()

  drop_query <- sprintf("DROP TABLE IF EXISTS public.%s CASCADE", tbl_name)
  if (drop_if_exists) dbx::dbxExecute(conn, drop_query)

  dbx::dbxExecute(conn, sql)
  dbx::dbxInsert(conn, tbl_name, csv)

  out <- dplyr::tbl(conn, tbl_name) |> dplyr::collect()
  return(out)
}
