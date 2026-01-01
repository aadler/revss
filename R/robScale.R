# Copyright (c) 2020, Avraham Adler All rights reserved
# SPDX-License-Identifier: BSD-2-Clause

# Robust Scale Estimator found in Rousseeuw & Verboven (2002)

robScale <- function(x, loc = NULL, implbound = 1e-4, na.rm = FALSE,
                     maxit = 80L, tol = sqrt(.Machine$double.eps)) {
  if (na.rm) {
    x <- x[!is.na(x)]
  } else if (anyNA(x)) {
    stop("There are NAs in the data yet na.rm is FALSE.")
  }

  if (!is.null(loc)) {
    x <- x - loc
    s <- 1.4826 * median(abs(x)) # MDZ in paper. Use 4 digits like mad in stats.
    t <- 0         # nolint object_overwrite_linter
    minobs <- 3L
  } else {
    s <- madn(x)
    t <- median(x) # nolint object_overwrite_linter
    minobs <- 4L
  }
  if (length(x) < minobs) {
    if (madn(x) <= implbound) {
      return(adm(x))
    } else {
      return(madn(x))
    }
  } else {
    b <- 0.37394112142347236
    converged <- FALSE
    k <- 0L
    while (!converged && k < maxit) {
      k <- k + 1L
      v <- sqrt(2 * mean((2 * plogis(((x - t) / s) / b) - 1) ^ 2))
      converged <- abs(v - 1) <= tol
      s <- s * v
    }
    return(s)
  }
}
