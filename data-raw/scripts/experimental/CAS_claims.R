## code to prepare `claims` dataset goes here

uri <- "https://casact.org/research/reserve_data/"
endpoint <- paste0(uri, "ppauto", "_pos.csv")

httr::GET(endpoint)

df <- readr::read_csv(endpoint, col_types = "iciiiddddddid")

urltools::url_compose(urltools::url_parse(uri))

usethis::use_data(claims, overwrite = TRUE)

FetchDataSet <- function(stub){
  URL.stem = "http://www.casact.org/research/reserve_data/"
  URL <- paste0(URL.stem, stub, "_pos.csv")
  df <- readr::read_csv(URL, col_types = "iciiiddddddid")
}


FetchDataSet("ppauto")
