# Copyright (c) 2020, Avraham Adler All rights reserved
# SPDX-License-Identifier: BSD-2-Clause

# Mean Absolute Deviation from the Median (Average Deviation from the Mean) with
# asymptotic bias correction. Patterned after 'mad' in stats

adm <- function(x, center = median(x), constant = NULL, na.rm = FALSE) {
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

  constant * mean(abs(x - center))
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
                 "2" = 1.414868530030482,
                 "3" = 1.2248005760050789,
                 "4" = 1.1547856730303148,
                 "5" = 1.1172756685718443,
                 "6" = 1.095847499979713,
                 "7" = 1.0802842674190594,
                 "8" = 1.068865412268323,
                 "9" = 1.0606623968690487,
                 n / (n - 0.51))
    rawAnswer <- mean(abs(x - mean(x)))
  } else {
    ne <- 2 * (n %/% 2) # Even floor of length. Constants exhibit step behavior.
    an <- switch(nc,
                 "2" = 1.414868530030482,
                 "3" = 1.4143972249472192,
                 "4" = 1.2031830896074811,
                 "5" = 1.2023267518622953,
                 "6" = 1.1345444408354397,
                 "7" = 1.1343843879404827,
                 "8" = 1.0999299985011299,
                 "9" = 1.1000963990699943,
                 ne / (ne - 0.76))
    rawAnswer <- mean(abs(x - median(x)))
  }

  const * an * rawAnswer
}
