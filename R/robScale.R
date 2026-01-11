# Copyright (c) 2020, Avraham Adler All rights reserved
# SPDX-License-Identifier: BSD-2-Clause

# Robust Scale Estimator found in Rousseeuw & Verboven (2002)

robScale <- function(x, loc = NULL, implbound = 1e-4, na.rm = FALSE,
                     maxit = 80L, tol = NULL, factors = c("AA", "CR")) {

  if (!is.numeric(x)) {
    stop("x contains non-numeric entries.")
  }

  if (na.rm) {
    x <- x[!is.na(x)]
  } else if (anyNA(x)) {
    stop("There are NAs in the data yet na.rm is FALSE.")
  }

  x <- as.double(x)

  if (is.null(tol)) {
    tol <- sqrt(.Machine$double.eps)
  } else {
    tol <- as.double(tol)
  }

  if (missing(factors)) {
    factors <- "AA"
  } else {
    factors <- match.arg(factors)
  }

  if (!is.null(loc)) {
    x <- x - loc
    s <- 1.4826 * medianR(abs(x)) # MDZ in paper. Use 4 digits like mad.
    t <- 0                        # nolint object_overwrite_linter
    minobs <- 3L
  } else {
    s <- madn(x, factors = factors)
    t <- medianR(x)              # nolint object_overwrite_linter
    minobs <- 4L
  }

  if (length(x) < minobs) {
    if (madn(x) <= implbound) {
      return(admn(x))
    } else {
      return(madn(x, factors = factors))
    }
  }

  .Call(robScale_c, x, t, as.double(s), as.integer(maxit), tol)
}
