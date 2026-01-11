# Copyright (c) 2025, Avraham Adler All rights reserved
# SPDX-License-Identifier: BSD-2-Clause

# Median Absolute Deviation with small-sample bias correction. CR parameters
# based on Croux & Rousseeuw (1992). AA parameters based on Monte Carlo by the
# package owner, paper forthcoming.


madf <- function(x, center = NULL, constant = 1.4826, na.rm = FALSE) {

  if (any(!is.numeric(x))) {
      stop("x contains a non-numeric argument.")
  }

  if (na.rm) x <- x[!is.na(x)]
  n <- length(x)
  if (n <= 1) {
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

# Can replace 'mad' in stats for small samples.

madn <- function(x, center = c("median", "mean"), factors = c("AA", "CR"),
                 na.rm = FALSE) {

  if (na.rm) x <- x[!is.na(x)]
  n <- length(x)
  if (n <= 1) {
    stop("There needs to be at least two values for a robust measure.")
  }
  nc <- as.character(n)

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
    no <- 2 * (n %/% 2) + 1L # Odd floor length; constants have step behavior.
    bn <- switch(nc,
                 "2" = 1.19521,
                 "3" = 0.94273,
                 "4" = 1.01705,
                 "5" = 1.07463,
                 "6" = 1.03163,
                 "7" = 1.02151,
                 "8" = 1.01934,
                 "9" = 1.02509,
                 no / (no - 0.19))
    return(bn * madf(x, center = mean(x)))
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
                           "2" = 1.19521,
                           "3" = 1.48695,
                           "4" = 1.36038,
                           "5" = 1.21604,
                           "6" = 1.19025,
                           "7" = 1.13863,
                           "8" = 1.12724,
                           "9" = 1.10157,
                           n / (n - 0.819)))
  bn * madf(x)

}
