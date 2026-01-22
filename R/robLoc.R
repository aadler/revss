# Copyright (c) 2020, Avraham Adler All rights reserved
# SPDX-License-Identifier: BSD-2-Clause

# Robust Location Estimator found in Rousseeuw & Verboven (2002)

robLoc <- function(x, scale = NULL, na.rm = FALSE, maxit = 80L, tol = NULL,
                   factors = c("AA", "CR")) {

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

  factors <- factors[1L]
  isCR <- factors == "CR"
  if (!isCR && factors != "AA") {
    stop("factors must be 'AA' or 'CR'", call. = FALSE)
  }

  if (is.null(tol)) {
    tol <- .revssConst$stdTol
  } else {
    tol <- as.double(tol)[1L]
  }

  if (!is.null(scale)) {
    minobs <- 3L
    s <- as.double(scale)[1L]
  } else {
    minobs <- 4L
    s <- madn(x, factors = factors)
  }

  med <- .Call(median_c, x)

  if (length(x) < minobs) {
    return(med)
  }

  .Call(robLoc_c, x, med, s, as.integer(maxit), tol)
}
