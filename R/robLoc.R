# Copyright (c) 2020, Avraham Adler All rights reserved
# SPDX-License-Identifier: BSD-2-Clause

# Robust Location Estimator found in Rousseeuw & Verboven (2002)

robLoc <- function(x, scale = NULL, na.rm = FALSE, maxit = 80L, tol = NULL,
                   factors = c("AA", "CR")) {

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

  if (!is.numeric(x)) {
    stop("x contains non-numeric entries.")
  }

  if (na.rm) {
    x <- x[!is.na(x)]
  } else if (anyNA(x)) {
    stop("There are NAs in the data yet na.rm is FALSE.")
  }

  x <- as.double(x)

  if (!is.null(scale)) {
    minobs <- 3L
    s <- scale
  } else {
    minobs <- 4L
    s <- madn(x, factors = factors)
  }

  if (length(x) < minobs) {
    return(medianR(x))
  }

  .Call(robLoc_c, x, medianR(x), as.double(s), as.integer(maxit), tol)
}
