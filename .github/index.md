# GitHub Folder

## Contents

- [Overview](#overview)
- [GitHub Action Workflows](#github-action-workflows)
  - [Status Badges](#status-badges)

## Overview

The folder houses GitHub-specific files, specifically:

- GitHub Labels Configuration `YAML` file: [`labels.yml`](labels.yml)
- GitHub Dependabot Configuration `YAML` file: [`dependabot.yml`](dependabot.yml)
- Suite of [GitHub Action Workflows](workflows/) in the [`.github/workflows/`](workflows/) folder.

## GitHub Action Workflows

Currently, this package employs the following suite of GitHub Actions in its CI/CD DevOps pipelines:

- [`check.yml`](workflows/check.yml): Performs a cross-platform package check (via `R CMD CHECK`) on every push and pull request into `main`.
- [`coverage.yml`](workflows/coverage.yml): Tests and runs code-coverage analysis (via `covr::codecov()`) on the package.
- [`docker.yml`](workflows/docker.yml): Builds package's `Dockerfile`'s for database(s) and APIs and pushes them to this repo's [GitHub Container Registry](https://github.com/jimbrig?tab=packages&repo_name=lossrx) or `ghcr.io`. See [actuarialdb]() for an example.
- [`document.yml`](workflows/document.yml): Roxygenize's the R Package by running `roxygen2::roxygenize()` (akin to `devtools::document()`).
- [`gh-release.yml`](workflows/gh-release.yml): Performs actions for a GitHub Release.
- [`gha-versions.yml`](workflows/gha-versions.yml): Updates the GitHub Actions versions themselves.
- [`git-cliff.yml`](workflows/git-cliff.yml): Updates the `CHANGELOG.md` via [git-cliff]().
- [`labels.yml`](workflows/labels.yml): Applies repo-specific GitHub Issue Labels
- [`linguist.yml`](workflows/linguist.yml): Applies `.gitattributes` for [GitHub-Linguist]().
- [`lint-changes.yml`](workflowss/lint-changes.yml): Only applies to pull-requests - lints code changes.
- [`lintr.yml`](workflows/lintr.yml): Lints the R Package codebase.
- [`pkgdown.yml`](workflows/pkgdown.yml): Creates and deploys the package documentation site via `pkgdown`.
- [`style.yml`](workflows/style.yml): Implements `styleR` on the R package.
- [`toc.yml`](workflows/toc.yml): Updates the `README.md`'s table of contents.

### Status Badges

- [![Code Coverage](https://github.com/jimbrig/lossrx/actions/workflows/coverage.yml/badge.svg)](https://github.com/jimbrig/lossrx/actions/workflows/coverage.yml)
- [![Create PkgDown](https://github.com/jimbrig/lossrx/actions/workflows/pkgdown.yml/badge.svg)](https://github.com/jimbrig/lossrx/actions/workflows/pkgdown.yml)
- [![Generate Changelog](https://github.com/jimbrig/lossrx/actions/workflows/git-cliff.yml/badge.svg)](https://github.com/jimbrig/lossrx/actions/workflows/git-cliff.yml)
