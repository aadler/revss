# Copyright (c) 2020, Avraham Adler All rights reserved
# SPDX-License-Identifier: BSD-2-Clause

# Robust Scale Estimator found in Rousseeuw & Verboven (2002)

robScale <- function(x, loc = NULL, implbound = 1e-4, na.rm = FALSE,
                     maxit = 80L, tol = NULL, madfctrs = c("AA", "CR"),
                     usefctrs = FALSE) {

  if (!is.numeric(x)) {
    stop("x contains non-numeric entries.")
  }

  if (na.rm) {
    x <- x[!is.na(x)]
  } else if (anyNA(x)) {
    stop("There are NAs in the data yet na.rm is FALSE.")
  }

  x <- as.double(x)
  n <- length(x)

  if (is.null(tol)) {
    tol <- sqrt(.Machine$double.eps)
  } else {
    tol <- as.double(tol)
  }

  if (missing(factors)) {
    madfctrs <- "AA"
  } else {
    madfctrs <- match.arg(factors)
  }

  if (!is.null(loc)) {
    x <- x - loc
    s <- 1.4826 * medianR(abs(x)) # MDZ in paper. Use 4 digits like mad.
    t <- 0                        # nolint object_overwrite_linter
    minobs <- 3L
  } else {
    s <- madn(x, factors = madfctrs)
    t <- medianR(x)              # nolint object_overwrite_linter
    minobs <- 4L
  }

  if (n < minobs) {
    if (madn(x) <= implbound) {
      return(admn(x))
    } else {
      return(madn(x, factors = madfctrs))
    }
  }

  rS <- .Call(robScale_c, x, t, as.double(s), as.integer(maxit), tol)
  if (usefctrs && is.null(loc)) {
    nc <- as.character(n)
    rn <- switch(nc,
                 "2" = 1.00033,
                 "3" = 1,
                 "4" = 1.30827,
                 "5" = 1.31918,
                 "6" = 1.21614,
                 "7" = 1.20221,
                 "8" = 1.16041,
                 "9" = 1.14768,
                 n / (n - 1.126))
  } else {
    rn <- 1
  }

  rn * rS
}
