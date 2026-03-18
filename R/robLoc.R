# Copyright (c) 2020, Avraham Adler All rights reserved
# SPDX-License-Identifier: BSD-2-Clause

# Robust Location Estimator found in Rousseeuw & Verboven (2002)

robLoc <- function(x, scale = NULL, factors = c("AA", "CR"), na.rm = FALSE,
                   opts = list()) {

  # Handle quick error returns first
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

  # Handle options
  nopts <- names(opts)

  if (!("maxit" %in% nopts)) {
    opts$maxit <- 80L
  } else {
    opts$maxit <- as.integer(opts$maxit)[1L]
  }

  if (!("tol" %in% nopts)) {
    opts$tol <- .revssConst$stdTol
  } else {
    opts$tol <- as.double(opts$tol)[1L]
  }

  # Handle passed variables
  factors <- factors[1L]
  isCR <- factors == "CR"
  if (!isCR && factors != "AA") {
    stop("factors must be 'AA' or 'CR'", call. = FALSE)
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

  .Call(robLoc_c, x, med, s, opts$maxit, opts$tol)
}
