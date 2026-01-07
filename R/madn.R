# Copyright (c) 2025, Avraham Adler All rights reserved
# SPDX-License-Identifier: BSD-2-Clause

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
  nc <- as.character(n)
  no <- 2 * (n %/% 2) + 1L # Odd ceiling of length. Constants are step-like.

  if (missing(center)) {
    center <- "median"
  } else {
    center <- match.arg(center)
  }

  if (missing(factors)) {
    factors <- "AA"
  } else {
    factors <- match.arg(factors)
  }

  if (center == "mean") {
    if (factors == "CR") {
      message("There are no factors in Croux & Rousseeuw for median absolute ",
              "deviation from the mean. Using Adler's factors.")
    }
    bn <- switch(nc,
                 "2" = 1.196057420160531,
                 "3" = 0.9430952345145196,
                 "4" = 1.0171093862026159,
                 "5" = 1.074608827423805,
                 "6" = 1.0315309939442419,
                 "7" = 1.0215452611271028,
                 "8" = 1.0194719125368632,
                 "9" = 1.0247557327860479,
                 no / (no - 0.19))
    return(bn * mad(x, center = mean(x)))
  }

  bn <- switch(factors,
               CR = switch(nc,
                           "2" = 1.196,
                           "3" = 1.495,
                           "4" = 1.363,
                           "5" = 1.206,
                           "6" = 1.2,
                           "7" = 1.14,
                           "8" = 1.129,
                           "9" = 1.107,
                           n / (n - 0.8)),
               AA = switch(nc,
                           "2" = 1.196057420160531,
                           "3" = 1.4882318165882795,
                           "4" = 1.3605298448399872,
                           "5" = 1.2158502434732232,
                           "6" = 1.1899706508997985,
                           "7" = 1.1388453803307483,
                           "8" = 1.1273180435759429,
                           "9" = 1.1010833093017414,
                           n / (n - 0.8)))
  bn * mad(x)

}
