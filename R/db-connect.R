#' Connect DB
#'
#' Connect to the Actuarial Database Instance.
#'
#' @param pool Logical - should the connection be pooled?
#'
#' @return a database connection
#' @export
#'
#' @importFrom config get
#' @importFrom dbx dbxConnect
#' @importFrom pool dbPool
#' @importFrom RPostgres Postgres
connect_db <- function(pool = TRUE) {
  config_file <- system.file(package = "lossrx", "database/config.yml")
  config <- config::get(file = config_file)$local_container

  if (pool) {
    conn <- pool::dbPool(
      RPostgres::Postgres(),
      dbname = config$dbname,
      host = config$server,
      user = config$user,
      password = config$password
    )
    connections::connection_view(pool::poolCheckout(conn))
  } else {
    conn <- dbx::dbxConnect(url = config$conn_string)
    connections::connection_view(conn)
  }

  conn
}
