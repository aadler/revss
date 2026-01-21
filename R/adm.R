# Copyright (c) 2020, Avraham Adler All rights reserved
# SPDX-License-Identifier: BSD-2-Clause

medianR <- function(x, na.rm = FALSE) {

  if (length(x) == 0) {
    return(NA_real_)
  }

  x <- as.double(x)

  if (na.rm) {
    x <- x[!is.na(x)]
    if (length(x) == 0) {
      return(NA_real_)
    }
  } else if (anyNA(x)) {
    return(NA_real_)
  }

  .Call(median_c, x)

}

adm <- function(x, center = NULL, constant = NULL, na.rm = FALSE) {

  if (length(x) == 0) {
    return(NA_real_)
  }

  x <- as.double(x)

  if (na.rm) {
    x <- x[!is.na(x)]
    if (length(x) == 0) {
      return(NA_real_)
    }
  } else if (anyNA(x)) {
    return(NA_real_)
  }

  n <- length(x)
  if (n <= 1) {
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

  if (length(x) == 0) {
    return(NA_real_)
  }

  x <- as.double(x)

  if (na.rm) {
    x <- x[!is.na(x)]
    if (length(x) == 0) {
      return(NA_real_)
    }
  } else if (anyNA(x)) {
    return(NA_real_)
  }

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

  # Asymptotic constant for both mean absolute deviation from the mean and mean
  # absolute deviation from the median is sqrt(pi / 2)
  const <- 1.2533141373155001

  if (center == "mean") {
    an <- switch(nc,
                 "2" = 1.41434,
                 "3" = 1.22469,
                 "4" = 1.15468,
                 "5" = 1.11797,
                 "6" = 1.09558,
                 "7" = 1.08009,
                 "8" = 1.06914,
                 "9" = 1.06072,
                 n / (n - 0.508))
    rawAnswer <- adm(x, sum(x) / n, 1)
  } else {
    ne <- 2 * (n %/% 2) # Even floor length; constants have step behavior.
    an <- switch(nc,
                 "2" = 1.41434,
                 "3" = 1.41413,
                 "4" = 1.20309,
                 "5" = 1.20305,
                 "6" = 1.13428,
                 "7" = 1.13411,
                 "8" = 1.10015,
                 "9" = 1.10012,
                 ne / (ne - 0.756))
    rawAnswer <- adm(x, medianR(x), 1)
  }

  const * an * rawAnswer
}
