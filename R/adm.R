# Copyright (c) 2020, Avraham Adler All rights reserved
# SPDX-License-Identifier: BSD-2-Clause

medianR <- function(x, na.rm = FALSE) {

  if (length(x) == 0L) {
    return(NA_real_)
  }

  x <- as.double(x)

  if (na.rm) {
    x <- x[!is.na(x)]
    if (length(x) == 0L) {
      return(NA_real_)
    }
  } else if (anyNA(x)) {
    return(NA_real_)
  }

  .Call(median_c, x)
}

adm <- function(x, center = NULL, constant = NULL, na.rm = FALSE) {

  if (length(x) == 0L) {
    return(NA_real_)
  }

  x <- as.double(x)

  if (na.rm) {
    x <- x[!is.na(x)]
    if (length(x) == 0L) {
      return(NA_real_)
    }
  } else if (anyNA(x)) {
    return(NA_real_)
  }

  n <- length(x)
  if (n <= 1L) {
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

  # Asymptotic constant for both mean absolute deviation from the mean and mean
  # absolute deviation from the median is sqrt(pi / 2)
  if (is.null(constant)) {
    constant <- .revssConst$sqrthalfpi
  } else {
    constant <- as.double(constant)[1L]
  }

  .Call(adm_c, x, center, constant)
}

# Mean Absolute Deviation from the Median (Average Deviation from the Mean) with
# small-sample bias correction.

admn <- function(x, center = c("median", "mean"), na.rm = FALSE) {

  if (length(x) == 0L) {
    return(NA_real_)
  }

  x <- as.double(x)

  if (na.rm) {
    x <- x[!is.na(x)]
    if (length(x) == 0L) {
      return(NA_real_)
    }
  } else if (anyNA(x)) {
    return(NA_real_)
  }

  n <- length(x)
  if (n <= 1L) {
    stop("There needs to be at least two values for a robust measure.")
  }

  center <- center[1L]
  is_mean <- center == "mean"
  if (!is_mean && center != "median") {
    stop("center must be 'median' or 'mean'", call. = FALSE)
  }

  if (is_mean) {
    if (n <= 9L) {
      an <- .revssConst$anAdmMean[n]
    } else {
      an <- n / (n - 0.508)
    }
    centerV <- sum(x) / n
  } else {
    ne <- 2 * (n %/% 2) # Even floor length
    if (n <= 9L) {
      an <- .revssConst$anAdmMed[n]
    } else {
      an <- ne / (ne - 0.756)
    }
    centerV <- .Call(median_c, x)
  }

  # Asymptotic constant for both mean absolute deviation from the mean and mean
  # absolute deviation from the median is sqrt(pi / 2)
  .revssConst$sqrthalfpi * an * .Call(adm_c, x, centerV, 1)
}
