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
    center <- medianR(x)
  } else {
    center <- as.double(center)[1L]
    if (is.na(center)) {
      return(NA_real_)
    }
  }

  # Asymptotic constant for both mean absolute deviation from the mean and mean
  # absolute deviation from the median is sqrt(pi / 2)
  if (is.null(constant)) {
    constant <- 1.2533141373155001 # sqrt(pi / 2)
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

  center <- match.arg(center)

  # Asymptotic constant for both mean absolute deviation from the mean and mean
  # absolute deviation from the median is sqrt(pi / 2)
  const <- 1.2533141373155001

  if (center == "mean") {
    an_adm_mean <- c(NA_real_,
                     1.41434,
                     1.22469,
                     1.15468,
                     1.11797,
                     1.09558,
                     1.08009,
                     1.06914,
                     1.06072)
    if (n <= 9L) {
      an <- an_adm_mean[n]
    } else {
      an <- n / (n - 0.508)
    }
    rawAnswer <- adm(x, sum(x) / n, 1)
  } else {
    ne <- 2 * (n %/% 2) # Even floor length
    an_adm_med <- c(NA_real_,
                    1.41434,
                    1.41434,
                    1.20307,
                    1.20307,
                    1.13420,
                    1.13420,
                    1.10014,
                    1.10014)

    if (n <= 9L) {
      an <- an_adm_med[n]
    } else {
      ne / (ne - 0.756)
    }
    rawAnswer <- adm(x, medianR(x), 1)
  }

  const * an * rawAnswer
}
