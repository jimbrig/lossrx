library(DBI)
library(readr)
library(RPostgres)
library(purrr)
library(tibble)
library(config)
library(dplyr)
library(dbplyr)

db_config <- config::get(file = "inst/database/config.yml")$local_container

conn <- dbx::dbxConnect(db_config$conn_string)
connections::connection_view(conn)

# Create the database
DBI::dbExecute(conn, 'CREATE DATABASE IF NOT EXISTS postgres;')

# Extensions
dbx::dbxExecute(conn, 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp";')

# Custom ENUM Types:
dbx::dbxExecute(conn, "CREATE TYPE GENDER AS ENUM ('Male', 'Female');")
dbx::dbxExecute(conn, "CREATE TYPE CLAIM_STATUS AS ENUM ('Open', 'Closed', 'Re-Opened');")
dbx::dbxExecute(conn, "CREATE TYPE ALAE_TREATMENT AS ENUM ('Loss', 'LossALAE', 'ProRata');")

tbls <- fs::dir_ls("data-raw/database/SQL") |> basename() |> fs::path_ext_remove()
db_data <- purrr::map(tbls, create_tbl)
