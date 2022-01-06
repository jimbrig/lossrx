# Data Preparation Directory - `data-raw`

## Folders

```bash
➜ tree data-raw
├───cache
├───database
│   ├───CSV
│   └───SQL
├───original
│   └───downloaded
├───scripts
└───working
    ├───exposures
    ├───industry
    ├───lossruns
    ├───policies
    └───priors
```

## Cache

A cache directory for intermediate caching of long-running data manipulations.

## Database

This directory represents the data preparation portion of the final [inst/database](../inst/database) folder which houses the final utilized 
database files.

In particular this folder should have:

- CSVs for each table (see [database/CSV](database/CSV))
- SQL table creation files for each table (see [database/SQL](database/SQL))
- Any other auxillary or referenced workbooks or data files that are implemented into the database
- A final `db.sql` SQL script that generates and seeds the database.

## Scripts

The [scripts](scripts) directory houses all the data preparation R scripts.

Currently the following scripts are used:

- [db_init.R](scripts/db_init.R): This script generates the database against a running PostgreSQL database container image.
- [dataprep.R](scripts/dataprep.R): This script downloads, extracts, and transforms data that is included, documented, and exported with the package as `.rda` files in the [data](../data) directory. Specifically, it generates the `losses` and `exposures` data frames.
- [claims_transactional.R](scripts/claims_transactional.R): This script *simulates* an example transactional claims dataset and is exported with the package as `claims_transactional`.

*Any other scripts are extras and may be ignored*.

## Original

The [original](original) directory houses raw, original data downloaded or brought in from an external source. This data is assumed to be as raw as possible.

## Working

The [working](working) directory houses data that has been manipulated from the files in the [original](original) directory. For example, extracted zips, renamed files, re-formatted tables, etc. The working data is what is actually used when preparing the datasets for use in 
the package.

Data Lineage: **ORIGINAL** --> **WORKING** --> **USED**

### Lossruns

Lossruns to be scrubbed.

### Exposures

Exposure Data for various scenarios and coverages.

### Industry Data

- Loss Development Factors (LDFs)
- Increased Limit Factors (ILFs)
- State filed loss-rates (Loss Costs)
- Trend Factors
- Decay Factors
- Ultimates or distributional parameters

### Prior Working Data

- Prior data to be used as if prior analysis have been performed in order to aid the Actual vs. Expected workflow.

