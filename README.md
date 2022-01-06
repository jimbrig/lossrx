
<!-- README.md is generated from README.Rmd. Please edit that file -->

# lossrx <img src='man/figures/logo.png' align="right" height="139" />

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![Project Status:
WIP](https://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip)
[![pkgdown](https://github.com/jimbrig/lossrx/actions/workflows/pkgdown.yaml/badge.svg)](https://github.com/jimbrig/lossrx/actions/workflows/pkgdown.yaml)
[![R-CMD-check](https://github.com/jimbrig/lossrx/workflows/R-CMD-check/badge.svg)](https://github.com/jimbrig/lossrx/actions)
[![codecov](https://codecov.io/gh/jimbrig/lossrx/branch/main/graph/badge.svg?token=14426d5e-bed0-4cea-b8ff-ff4561ccda4f)](https://codecov.io/gh/jimbrig/lossrx?branch=main)
<!-- badges: end -->

*View the [Changelog](inst/CHANGELOG.md) for detailed progression on development of the package.*

## Overview

The desired outcome of the `lossrx` R package is to provide actuaries and data scientists valuable tools and frameworks for performing Property Casualty related workflows.

Specifically, the package will contain:

- A suite of utility and workflow oriented functions bundled as an R package
- A plumber API that serves various endpoints related to a backend database and models
- A comprehensive, yet simple migration-friendly relational database representing the various entities, attributes, and relationships involved with actuarial reserving.[^1]
- A demo Shiny App for Actuarial Loss Development and Reserving including triangles, loss development factor selection, preliminary ultimates, etc. and a backend database/API to store results and selections.
- Comprehensive documentation and tests

## Data Prep

This package utilizes a lot of data and in turn has a lot of code inside the [data-raw](data-raw) folder. I recommend taking a look at its [README](data-raw/README.md) to gain an understanding of how the data was prepared for both use in the package as well as included and uploaded to the database.

### Database

The core database files are housed in the [inst/database](inst/database) directory and are included on package installation.

## Installation

You can install the development version of `lossrx` with `pak`: [^2]

```r
pak::pak("jimbrig/lossrx")
```

[^1]: See the [database container package](https://github.com/jimbrig/lossrx/pkgs/container/actuarialdb) for details on how to run the database as a container image.

[^2]: Similarly, you can install the package using the more common `devtools::install_github()` and `remotes::install_github()`

***

Jimmy Briggs | 2022