# Copyright (c) 2020, Avraham Adler All rights reserved
# SPDX-License-Identifier: BSD-2-Clause

# Mean Absolute Deviation from the Median (Average Deviation from the Mean) with
# asymptotic bias correction. Patterned after 'mad' in stats

# adm <- function(x, center = median(x), constant = NULL, na.rm = FALSE) {
#   if (na.rm) x <- x[!is.na(x)]
#   n <- length(x)
#   if (n <= 1) {
#     stop("There needs to be at least two values for a robust measure.")
#   }
#
#   # Asymptotic constant for both mean absolute deviation from the mean and mean
#   # absolute deviation from the median is sqrt(pi / 2)
#   if (is.null(constant)) {
#     constant <- 1.2533141373155001 # sqrt(pi / 2)
#   }
#
#   constant * mean(abs(x - center))
# }

adm <- function(x, center = median(x), constant = NULL, na.rm = FALSE) {
  if (any(is.character(x))) {
    stop("x contains a non-numeric argument.")
  }

  if (na.rm) x <- x[!is.na(x)]
  n <- length(x)
  if (n <= 1) {
    stop("There needs to be at least two values for a robust measure.")
  }

  # Asymptotic constant for both mean absolute deviation from the mean and mean
  # absolute deviation from the median is sqrt(pi / 2)
  if (is.null(constant)) {
    constant <- 1.2533141373155001 # sqrt(pi / 2)
  }

  .Call(adm_c, as.double(x), as.double(center), as.double(constant))
}

# Mean Absolute Deviation from the Median (Average Deviation from the Mean) with
# small-sample bias correction.

admn <- function(x, center = c("median", "mean"), na.rm = FALSE) {

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

  # Asymptotic constant for both mean absolute deviation from the mean and mean
  # absolute deviation from the median is sqrt(pi / 2)
  const <- 1.2533141373155001

  if (center == "mean") {
    an <- switch(nc,
                 "2" = 1.41386,
                 "3" = 1.22459,
                 "4" = 1.15476,
                 "5" = 1.11763,
                 "6" = 1.09585,
                 "7" = 1.08042,
                 "8" = 1.06887,
                 "9" = 1.06098,
                 n / (n - 0.509))
    rawAnswer <- mean(abs(x - mean(x)))
  } else {
    no <- 2 * (n %/% 2) + 1L # Odd floor length; constants have step behavior.
    an <- switch(nc,
                 "2" = 1.41386,
                 "3" = 1.41402,
                 "4" = 1.20311,
                 "5" = 1.20265,
                 "6" = 1.13459,
                 "7" = 1.1345,
                 "8" = 1.09993,
                 "9" = 1.10042,
                 no / (no - 0.805))
    rawAnswer <- mean(abs(x - median(x)))
  }

  const * an * rawAnswer
}
