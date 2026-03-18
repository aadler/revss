# Copyright (c) 2025, Avraham Adler All rights reserved
# SPDX-License-Identifier: BSD-2-Clause

madf <- function(x, center = NULL, constant = 1.4826, na.rm = FALSE) {
  # Internal fast Median Absolute Deviation from Center coded in Fortran
  # Constant is the same as stats::mad; a truncation of 1 / qnorm(0.75)

  x <- as.double(x)

  if (!na.rm && anyNA(x)) {
    return(NA_real_)
  }

  if (na.rm) x <- x[!is.na(x)]

  if (length(x) <= 1L) {
    stop("There needs to be at least two values for a robust measure.")
  }

  if (is.null(center)) {
    center <- .Call(median_c, x)
  } else {
    center <- as.double(center)[1L]
    if (is.na(center)) {
      return(NA_real_)
    }
  }

  .Call(mad_c, x, center, as.double(constant)[1L])
}

# Median Absolute Deviation with small-sample bias correction. CR parameters
# based on Croux & Rousseeuw (1992). AA parameters based on Monte Carlo by the
# package owner, paper forthcoming.
# Can replace 'mad' in stats for small samples.
# Constant of 1.4826 is the same as stats::mad; a truncation of 1 / qnorm(0.75)

madn <- function(x, center = c("median", "mean"), factors = c("AA", "CR"),
                 na.rm = FALSE) {

  x <- as.double(x)

  if (!na.rm && anyNA(x)) {
    return(NA_real_)
  }

  if (na.rm) x <- x[!is.na(x)]

  n <- length(x)
  if (n <= 1L) {
    stop("There needs to be at least two values for a robust measure.")
  }

  center <- center[1L]
  is_mean <- center == "mean"
  if (!is_mean && center != "median") {
    stop("center must be 'median' or 'mean'", call. = FALSE)
  }

  factors <- factors[1L]
  isCR <- factors == "CR"
  if (!isCR && factors != "AA") {
    stop("factors must be 'AA' or 'CR'", call. = FALSE)
  }

  ne <- 2 * (n %/% 2)             # Even floor length.
  no <- 2 * ((n + 1) %/% 2) - 1   # Odd floor length.

  if (is_mean) {
    if (isCR) {
      warning("There are no factors in Croux & Rousseeuw for median absolute ",
              "deviation from the mean. Using Adler's factors.", call. = FALSE)
    }

    bn <- if (n <= 9L) .revssConst$bnMdADM[n] else ne / (ne - .revssConst$bnMdADM[10L])
    bn <- if (n <= 9L) {
      .revssConst$bnMdADM[n]
    } else {
      ne / (ne - .revssConst$bnMdADM[10L])
    }

    return(bn * .Call(mad_c, x, sum(x) / n, 1.4826))
  }

  if (isCR) {
    bn <- if (n <= 9L) .revssConst$bnMdADMdCR[n] else n / (n - .revssConst$bnMdADMdCR[10L])
    bn <- if (n <= 9L) {
      .revssConst$bnMdADMdCR[n]
    } else {
      n / (n - .revssConst$bnMdADMdCR[10L])
    }
  } else {
    bn <- if (n <= 9L) .revssConst$bnMdADMdAA[n] else no / (no - .revssConst$bnMdADMdAA[10L])
    bn <- if (n <= 9L) {
      .revssConst$bnMdADMdAA[n]
    } else {
      no / (no - .revssConst$bnMdADMdAA[10L])
    }
  }

  bn * .Call(mad_c, x, .Call(median_c, x), 1.4826)
}
