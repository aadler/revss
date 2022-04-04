# Copyright (c) 2020, Avraham Adler All rights reserved
# SPDX-License-Identifier: BSD-2-Clause

# Robust Location Estimator found in Rousseeuw & Verboven (2002)

robLoc <- function(x, scale = NULL, na.rm = FALSE, maxit = 80L,
                   tol = sqrt(.Machine$double.eps)) {
  if (na.rm) {
    x <- x[!is.na(x)]
  } else {
    if (anyNA(x)) {
      stop("There are NAs in the data yet na.rm is FALSE")
    }
  }
  if (!is.null(scale)) {
    minobs <- 3L
    s <- scale
  } else {
    minobs <- 4L
    s <- mad(x)
  }
  if (length(x) < minobs) {
    return(median(x))
  } else {
    t <- median(x)
    converged <- FALSE
    k <- 0L
    while (!converged && k < maxit) {
      k <- k + 1L
      v <- s * mean((2 * plogis((x - t) / s) - 1) / 0.413241928283814)
      converged <- abs(v) <= tol
      t <- t + v
    }
    return(t)
  }
}
