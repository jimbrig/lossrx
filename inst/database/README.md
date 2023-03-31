# Database for `lossrx` Package: `actuarialdb`

## TLDR

Get up-and-running by simply entering this folder and running
`docker-compose up --build` to build and run a container instance of the
[actuarialdb]() locally on port 5432.

For reference here is the docker-compose.yml file:

``` dockerfile
services:
    postgres:
        image: postgres:latest
        restart: always
        environment:
            POSTGRES_USER: postgres
            POSTGRES_PASSWORD: admin
            POSTGRES_DB: postgres
        logging:
            options:
                max-size: 10m
                max-file: "3"
        ports:
            - '5432:5432'
        volumes:
            - ./postgres-data:/var/lib/postgresql/data
            - ./SQL:/docker-entrypoint-initdb.d
```

## Structure

``` bash
> tree inst/database

./inst/database
├── db.dbml
├── db.sql
├── Dockerfile
├── docker-compose-yml
├── package.json
├── config.yml
├── README.md
├── .vscode/
├── postgres-data/
├── backups/
├── scripts/
├── docs/
├── CSV/
├── SQL/
└── YAML/

8 directories, 7 files
```

## Root Level Files

-   [db.sql](db.sql): `SQL` script to generate database schema -
    autogenerated using [DBML (Database Markup Language) Command Line
    Tool](https://www.dbml.org/home/#command-line-tool-cli) by running
    `dbml2sql db.dbml` against the [db.dbml](db.dbml) markup file.

-   [db.dbml](db.dbml): `DBML` (Database Markup Language) script for
    converting `SQL` into documentation. I originally generated this
    document using [dbdiagram](https://dbdiagram.io/).

-   [Dockerfile](Dockerfile) and [docker-compose.yml]: Used to create
    database PostgreSQL container instance.

-   [config.yml](config.yml): Used by the R package `config` to load
    database connection credentials and gain access to the database
    from R.

## postgres-data

This directory is mapped to the docker containers volume as a locally
mounted docker volume to store postgresql data related to the database
and persist this data across container runtimes. Most of this
directories contents are git ignored, however I left some configs for
observational purposes.

## Scripts

The [scripts](scripts) directory houses various utility `.sh`, `.R`,
`.ps1`, etc. scripts or queries related to our database.

## Backups

The [backup](backups) directory houses any snapshots or database backup
files.

## SQL

SQL scripts to create database schema and tables.

## CSV

CSV data files to seed data into the database tables.

## YAML

YAML configuration files representing the database schema by table.

## Design

### Introduction

The actuarial database is meant to serve as an enterprise data model
(EDM) which captures the semantics, operations, and relationships
relevant to a Property Casualty Operating Business Model.

It is important to note the difference between *Transactional* vs.
*Analytical* data warehouse implementations as well as how to deal with
*multi-dimensional* *online analytical processing (OLAP)* data
structures.

For example, a *triangle* which gets derived from a suite of *lossruns*
is a structure representing claim values over time grouped by evaluation
dates, accident/policy years, and coverage (with optional further
segmentation i.e. limits, divisions, segments, lines of business, etc.).
This is a multi-dimensional data series.

When dealing with multi-dimensional data structures the optimal data
warehouse implementation is a *dimension fact table design* where a
central *claims* fact table is supplemented by various dimension tables
which contain claim attributes.

### Inspiration

#### OMG's Property Casualty Data Model Specification

Among the components of the P&C data model, there are the entities,
attributes and relationships.

The main objects of the data model are the Entities. An Entity
represents a person, organization, place, thing, or concept of interest
to the enterprise.

Next, an Entity can express a very broad and varied set of instance
data, or it can be very specific. This is referred to as *levels of
abstraction*.

Some examples of the core entities are:

− **Insurable Object**: An Insurable Object is an item which may be
included or excluded from an insurance coverage or policy, either as the
object for which possible damages of the object or loss of the object is
insured, or as the object for which damages caused by the object are
insured.

-   Examples: residence, vehicle, class of employees.  
    − **Vehicle**: A Vehicle is an Insured Object that is a conveyance
    for transporting people and/or goods.  
    − **Person**: Person can be a human being, either alive or dead.  
    − **Organization**: An Organization is a Party that is a business
    concern or a group of individuals that are systematically bound by a
    common purpose. Organizations may be legal entities in their own
    right.  
-   Examples: commercial organizations such as limited companies,
    publicly quoted multinationals, subsidiaries.  
    − **Agreement**: Agreement is language that defines the terms and
    conditions of a legally binding contract among the identified
    parties, ordinarily leading to a contract.  
-   Examples; policy, reinsurance agreement, staff agreement.  
    − **Claim**: Claim is a request for indemnification by an insurance
    company for loss incurred from an insured peril or hazard.  
    − **Claim Amount**: Claim Amount is the money being paid or
    collected for settling a claim and paying the claimants,
    re-insurers, other insurers, and other interested parties. Claim
    amounts are classified by various attributes.  
    − **Policy Coverage Detail**: Policy Coverage Detail defines the
    coverage's included in an insurance policy (refer to Coverage
    definition). It is a key link in the data model among Policy, Claim,
    and Reinsurance.

Relationships:

An *Insurable Object* is covered as defined in a *Policy Detail* by its
*Coverage* (One to Many).

A Claim is settled and results in a Claim Amount

![](C:/Users/jimmy/AppData/Local/RStudio/tmp/paste-698FF987.png)