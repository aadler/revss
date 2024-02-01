---
title: Contributions
---

# Contributions
Please ensure that all contributions comply with both
[R and CRAN standards for packages](https://cran.r-project.org/doc/manuals/r-release/R-exts.html).

## Versioning
This project attempts to follow [Semantic Versioning](https://semver.org/).
However, so long as the package remains in its experimental development
state---noted by a 0 major version---the API may change without incrementing the
major version. Please read the development notes
([NEWS](https://CRAN.R-project.org/package=minimaxApprox/news.html)) carefully.
Breaking changes will be prefaced by "**Breaking:**".

## Changelog
This project attempts to follow the changelog system at
[keep a changelog](https://keepachangelog.com/).

## Dependencies
This project intends to have as few dependencies as possible. Please consider
that when writing code.

## Style
Please conform to this
[coding style guide](https://www.avrahamadler.com/coding-style-guide/) as best
possible.

## Documentation
Please provide valid .Rd files and **not** roxygen-style documentation.

## Tests
Please review the current test suite and supply similar `tinytest`-compatible
unit tests for all added functionality.

## Submission
If you would like to contribute to the project, it may be prudent to first
contact the maintainer via email. A request or suggestion may be raised as an
issue as well. To supply a pull request (PR), please:

 1. Fork the project and then clone into your own local repository
 2. Create a branch in your repository in which you will make your changes
 3. Ideally use -s to sign-off on commits under the
 [Developer Certificate of Origin](https://developercertificate.org/).
 4. If possible, sign commits using a GPG key.
 5. Push that branch and then create a pull request

At this point, the PR will be discussed and eventually accepted or rejected by
the lead maintainer.
