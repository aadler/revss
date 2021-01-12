<!-- badges: start -->
[![](https://www.r-pkg.org/badges/version-last-release/revss)]
[![](https://cranlogs.r-pkg.org/badges/revss)]
[![R build status](https://github.com/aadler/revss/workflows/R-CMD-check/badge.svg)](https://github.com/aadler/revss/actions)
[![Codecov test coverage](https://codecov.io/gh/aadler/revss/branch/master/graph/badge.svg)](https://codecov.io/gh/aadler/revss?branch=master)
<!-- badges: end -->

# revss
**revss** is an `R` package which implements the estimation techniques described
in [Rousseeuw & Verboven (2002)](https://www.researchgate.net/publication/223864903_Robust_estimation_in_very_small_samples)
for the location and scale of very small samples.

## Citation
If you use the package, please cite it as:

  Avraham Adler (2020). revss: Robust Estimation in Very Small Samples.
  R package version 1.0.1.
  https://CRAN.R-project.org/package=revss

A BibTeX entry for LaTeX users is:

```
  @Manual{,
    title = {revss: Robust Estimation in Very Small Samples},
    author = {Avraham Adler},
    year = {2020},
    url = {https://CRAN.R-project.org/package=revss},
    note = {R package version 1.0.1},
  }
```

## Acknowledgements
The author is grateful Dr. Peter Rousseeuw for his response to this
[MathExchange](https://math.stackexchange.com/questions/2447019/source-for-claim-by-rousseeuw-verboven-regarding-robust-newton-raphson)
question about the implementation.

## Contributions
Please ensure that all contributions comply with both
[R and CRAN standards for packages](https://cran.r-project.org/doc/manuals/r-release/R-exts.html).

### Versioning
This project attempts to follow [Semantic Versioning](https://semver.org/)

### Changelog
This project attempts to follow the changelog system at
[Keep a CHANGELOG](https://keepachangelog.com/)

### Dependancies
This project intends to have as few dependancies as possible. Please consider
that when writing code.

### Style
Please review and conform to the current code stylistic choices (e.g. 80
character lines, two-space indentations).

### Documentation
Please provide valid .Rd files and **not** roxygen-style documentation.

### Tests
Please review the current test suite and supply similar `testthat`-compatible
unit tests for all added functionality.

### Submission
If you would like to contribute to the project, it may be prudent to first
contact the maintainer via email. A request or suggestion may be raised as an
issue as well. To supply a pull request (PR), please:

 1. Fork the project into your own local repository
 2. Create a branch in your repository in which you will make your changes
 3. Push that branch to Bitbucket and then create a pull request

At this point, the PR will be discussed and eventually accepted or rejected.
