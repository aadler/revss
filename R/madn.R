# Copyright (c) 2025, Avraham Adler All rights reserved
# SPDX-License-Identifier: BSD-2-Clause

madf <- function(x, center = NULL, constant = 1.4826, na.rm = FALSE) {
  # Internal fast Median Absolute Deviation from Center coded in Fortran

  if (!all(is.numeric(x))) {
      stop("x contains a non-numeric argument.")
  }

  if (na.rm) x <- x[!is.na(x)]

  if (length(x) <= 1) {
    stop("There needs to be at least two values for a robust measure.")
  }

  x <- as.double(x)

  if (is.null(center)) {
    center <- medianR(x)
  } else {
    center <- as.double(center)
  }

  .Call(mad_c, x, center, as.double(constant))
}

# Median Absolute Deviation with small-sample bias correction. CR parameters
# based on Croux & Rousseeuw (1992). AA parameters based on Monte Carlo by the
# package owner, paper forthcoming.
# Can replace 'mad' in stats for small samples.

madn <- function(x, center = c("median", "mean"), factors = c("AA", "CR"),
                 na.rm = FALSE) {

  if (na.rm) x <- x[!is.na(x)]

  n <- length(x)
  if (n <= 1) {
    stop("There needs to be at least two values for a robust measure.")
  }

  center <- match.arg(center)
  factors <- match.arg(factors)

  ne <- 2 * (n %/% 2)             # Even floor length.
  no <- 2 * ((n + 1) %/% 2) - 1   # Odd floor length.

  if (center == "mean") {
    if (factors == "CR") {
      message("There are no factors in Croux & Rousseeuw for median absolute ",
              "deviation from the mean. Using Adler's factors.")
    }

    bn_mad_mean_AA <- c(NA_real_,
                        1.19561,
                        0.94279,
                         1.01703,
                         1.07511,
                         1.03119,
                         1.02084,
                         1.01958,
                         1.02468)

    bn <- if (n <= 9) {
      bn_mad_mean_AA[n]
    } else {
      ne / (ne - 0.18)
    }

    return(bn * madf(x, center = sum(x) / n))
  }

  bn_mad_med_CR <- c(NA_real_,
                     1.196,
                     1.495,
                     1.363,
                     1.206,
                     1.2,
                     1.14,
                     1.129,
                     1.107)

  bn_mad_med_AA <- c(NA_real_,
                     1.19561,
                     1.48701,
                     1.36067,
                     1.217,
                     1.18973,
                     1.13773,
                     1.12735,
                     1.10113)

  bn <- if (factors == "CR") {
    if (n <= 9) {
      bn_mad_med_CR[n]
    } else {
      n / (n - 0.8)
    }
  } else {
    if (n <= 9) {
      bn_mad_med_AA[n]
    } else {
      no / (no - 0.786)
    }
  }

  bn * madf(x)

}
