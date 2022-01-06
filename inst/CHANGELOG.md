# Changelog
All notable changes to this project will be documented in this file.

## [Unreleased]

### Configuration

- Re-configure pkgdown
- Pkgdown
- Match-up vignette names and indices
- Cleanup old data-raw doc_data function
- Cleanup old unused files
- New dependency packages
- Build ignore codemeta.json
- Configure gh-linguist to ignore HTML and CSS
- Buildignore gitattributes
- Ignore javascript also with linguist
- Re-structure data-raw folders

### Documentation

- Re-document package
- Re-document package pre-build
- Various tweaks to vignettes
- Pkgdown configs
- Add footnote to readme for database docker image
- Add comprehensive data-raw README
- Enhance README

### Features

- Add string utility functions
- Add date utility functions
- Add data utility functions
- Initialize statistical functions
- Re-configure R directory with function groupings
- Add database create_tbl function
- Add suite of interpolation functions
- Add database schema YAML configuration files
- Create database connection configuration file
- Initialize vignettes for statistical distributions
- Add customized vignette CSS styles
- Initialize data overview vignette
- SQL files for vehicles, coverages, and claimants
- Database initialization script
- Restructure and enhance data-raw folder
- Add dependencies
- Add bugReports URL
- Add db.sql copied from docker container
- Complete the inst/database folder

### Miscellaneous Tasks

- Autopublish 2022-01-02T01:56:07Z
- Autopublish 2022-01-02T02:00:09Z
- Autopublish 2022-01-02T02:01:50Z
- Autopublish 2022-01-02T02:06:49Z
- Autopublish 2022-01-02T02:08:20Z
- Autopublish 2022-01-02T02:10:52Z
- Autopublish 2022-01-02T02:18:30Z
- Autopublish 2022-01-02T02:23:52Z
- Autopublish 2022-01-02T02:36:18Z
- Autopublish 2022-01-02T02:37:56Z
- Autopublish 2022-01-02T02:41:36Z
- Autopublish 2022-01-05T02:26:14Z
- Autopublish 2022-01-05T02:28:46Z
- Autopublish 2022-01-05T02:29:40Z
- Autopublish 2022-01-05T02:31:21Z
- Autopublish 2022-01-05T02:37:55Z
- Autopublish 2022-01-05T02:42:44Z
- Autopublish 2022-01-05T02:47:14Z
- Autopublish 2022-01-06T00:08:43Z
- Autopublish 2022-01-06T00:12:26Z
- Autopublish 2022-01-06T00:13:53Z
- Autopublish 2022-01-06T00:15:04Z

### Bug

- Fix NEWS.md

### Data

- Updated .rda data files
- Database CSV seeding files

### Meta

- Create codemetar config file

## [0.0.2] - 2022-01-02

### Configuration

- Update pkgdevt script
- Tweak DESCRIPTION
- Update NAMESPACE imports
- Update DESCRIPTION imports
- Delete validation
- Comment out old interpolations
- Delete auto_claims
- Pkgdown bump version

### Documentation

- Document datasets and loss_run function
- Add data documentation data.R file
- Add overview vignette
- Update CHANGELOG.md
- Document and export interp functions
- Interpolation formula man images 
- Update CHANGELOG.md for interp feature branch merge
- Add params for methods of interp generic
- Add interp to pkgdown config

### Features

- Add chamemelon open_pkgdown function
- Add new loss_run aggregation function
- Begin exploring interpolation methods
- Add new interp generic function
- Update pkgdevt.R script
- Initialize validation functions
- Fix documentation related issues
- Remove auto_data 
- Bump version

### Miscellaneous Tasks

- Autopublish 2021-11-28T05:43:05Z
- Autopublish 2021-11-28T05:47:33Z
- Autopublish 2021-11-28T05:49:10Z
- Autopublish 2021-11-28T05:50:35Z
- Autopublish 2021-11-28T05:52:38Z
- Autopublish 2021-12-08T00:51:17Z
- Autopublish 2021-12-08T01:02:01Z
- Autopublish 2021-12-21T05:22:56Z
- Autopublish 2022-01-02T01:51:06Z

### Testing

- Add testdown report for unit tests
- Add tests for loss_run
- Add unit tests for loss_run
- Add unit tests for interp function

### Data

- Add auto liability claims data
- Add claims data
- Add transactional claims
- Bundle .rda data files
- Incorporate dataprep caching for simulations

### Release

- For initial release docs

## [0.0.1] - 2021-11-28

### Configuration

- Rbuildignore git-cliff cliff.toml config file
- Update buildignore and gitignore
- Add new dependencies to DESCRIPTION
- Update pgkdevt with new enhancements
- Cleanup old files
- Update NAMESPACE
- Add separate pkgdown config for chameleon
- Edit github labels

### Documentation

- Add NEWS.md
- R package documentation
- Utility helpers man pages
- Create overview of loss reserving initial vignette
- Add package hex logo to inst/images
- Knit initial README.md (with logo)
- Add hex logo to man directory
- Initialize git-cliff for CHANGELOG.md generation
- Extra images
- Add CHANGELOG to README
- Sync NEWS.md and CHANGELOG.md
- Run `usethis::use_pkgdown_github_pages()`
- Update DESCRIPTION and pkgdoc
- Update CHANGELOG.md
- Update news.md
- Add favicons
- Overview vignette
- Add pkgdown gh action badge to readme
- Render pkgdown on develop branch too
- Enhance pkgdown config
- Document new man pages
- Update README with new badges
- Update CHANGELOG
- Update README
- Fix README and NEWS

### Features

- Add license
- Add new triangle functions and initialize tests
- Add git-cliff GH action workflow
- Add new github actions (check and coverage)
- Add a build-prep helper script
- Add dev_dependencies
- Add spelling wordlist
- Add zzz.R for any onload calls
- Add feedback utility function helpers
- Add new date utility helpers
- Add new data utility helpers
- Add globals.R
- Add loss_run actuarial function
- Add triangles structure, generics, and methods
- Initialize actuarial validation check functions
- Add initial suite of testthat unit tests

### Infrastructure

- Initialize R package structure via `usethis`
- Create data-raw for preparing claims data
- Backup package commands to `pkgdevt.R`
- Add some utility imports

### Miscellaneous Tasks

- Autopublish 2021-11-24T02:29:14Z
- Autopublish 2021-11-28T05:18:05Z
- Autopublish 2021-11-28T05:20:09Z

### Testing

- Initialize tests with testthat

### Bug

- Fix malformed maintainer in DESCRIPTION
- Tweak cliff.toml typo
- Fix pkgdown config for unreleased sections

***
Jimmy Briggs | 2021
*Changelog generated via `git-cliff`*
