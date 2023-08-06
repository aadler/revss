<!-- badges: start -->
[![CRAN Status Badge](https://www.r-pkg.org/badges/version/revss)](https://CRAN.R-project.org/package=revss)
[![](https://cranlogs.r-pkg.org/badges/last-month/revss)](https://cran.r-project.org/package=revss)
[![](https://cranlogs.r-pkg.org/badges/grand-total/revss)](https://cran.r-project.org/package=revss)
[![R-CMD-check](https://github.com/aadler/revss/workflows/R-CMD-check/badge.svg)](https://github.com/aadler/revss/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/aadler/revss/branch/master/graph/badge.svg)](https://app.codecov.io/gh/aadler/revss?branch=master)
[![OpenSSF Best Practices](https://bestpractices.coreinfrastructure.org/projects/5541/badge)](https://bestpractices.coreinfrastructure.org/projects/5541)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.5874911.svg)](https://doi.org/10.5281/zenodo.5874911)
<!-- badges: end -->

# revss
**revss** is an `R` package which implements the estimation techniques described
in [Rousseeuw & Verboven (2002)](https://www.researchgate.net/publication/223864903_Robust_estimation_in_very_small_samples)
for the location and scale of very small samples.

## Citation
If you use the package, please cite it as:

  Avraham Adler (2020). revss: Robust Estimation in Very Small Samples.
  R package version 1.0.5.
  doi: 10.5281/zenodo.5874911
  https://CRAN.R-project.org/package=revss

A BibTeX entry for LaTeX users is:

```
  @Manual{,
    title = {revss: Robust Estimation in Very Small Samples},
    author = {Avraham Adler},
    year = {2020},
    url = {https://CRAN.R-project.org/package=revss},
    doi = {10.5281/zenodo.5874911},
    note = {R package version 1.0.5},
  }
```

## Acknowledgements
The author is grateful Dr. Peter Rousseeuw for his response to this
[MathExchange](https://math.stackexchange.com/q/2447019) question about the
implementation.

## Contributions
Please ensure that all contributions comply with both
[R and CRAN standards for packages](https://cran.r-project.org/doc/manuals/r-release/R-exts.html).

### Versioning
This project attempts to follow [Semantic Versioning](https://semver.org/)

### Changelog
This project attempts to follow the changelog system at
[Keep a CHANGELOG](https://keepachangelog.com/)

### Dependancies
This project intends to have as few dependencies as possible. Please consider
that when writing code.

### Style
Please conform to this
[coding style guide](https://www.avrahamadler.com/coding-style-guide/) as best
possible.

### Documentation
Please provide valid .Rd files and **not** roxygen-style documentation.

### Tests
Please review the current test suite and supply similar `tinytest`-compatible
unit tests for all added functionality.

### Submission
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

## Roadmap
### Major

 * There are no plans for major changes at current
 
### Minor
 
 * There are no plans for minor changes at current
 
## Security
### Expectations
This package is a calculation engine and requires no secrets or private
information. It is checked for memory leaks prior to releases to CRAN using
ASAN/UBSBAN. Dissemination is handled by CRAN. Bugs are reported via the tracker
and handled as soon as possible.

### Assurance
The threat model is that a malicious actor would "poison" the package code by
adding in elements having nothing to do with the package's purpose but which
would be used for malicious purposes. This is protected against by having the
email account of the maintainer—used for verification by CRAN—protected by a
physical 2FA device (Yubikey) which is carried by the lead maintainer.
