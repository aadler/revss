# Copyright (c) 2020, Avraham Adler All rights reserved
# SPDX-License-Identifier: BSD-2-Clause

# Robust Scale Estimator found in Rousseeuw & Verboven (2002)

robScale <- function(x, loc = NULL, na.rm = FALSE, opts = list()) {

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

  n <- length(x)

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

  if (!("usefctrs" %in% nopts)) {
    opts$usefctrs <- TRUE
  } else {
    opts$usefctrs <- as.logical(opts$usefctrs)[1L]
  }

  if (!("madfctrs" %in% nopts)) {
    opts$madfctrs <- "AA"
  } else {
    opts$madfctrs <- opts$madfctrs[1L]
    isCR <- opts$madfctrs == "CR"
    if (!isCR && opts$madfctrs != "AA") {
      stop("madfctrs must be 'AA' or 'CR'", call. = FALSE)
    }
  }

  if (!("implbound" %in% nopts)) {
    opts$implbound <- 1e-4
  } else {
    opts$implbound <- as.double(opts$implbound)[1L]
  }

  haveLoc <- !is.null(loc)

  if (haveLoc) {
    x <- x - loc
    s <- 1.4826 * .Call(median_c, abs(x)) # MDZ in paper. Already protected
    t <- 0                        # nolint object_overwrite_linter
    minobs <- 3L
  } else {
    s <- madn(x, factors = opts$madfctrs)
    t <- .Call(median_c, x)   # nolint object_overwrite_linter Already protected
    minobs <- 4L
  }

  if (n < minobs) {
    m <- madn(x, factors = opts$madfctrs)
    return(if (m <= opts$implbound) admn(x) else m)
  }

  rS <- .Call(robScale_c, x, t, s, opts$maxit, opts$tol)

  if (!opts$usefctrs) {
    rn <- 1
  } else {
    if (haveLoc) {
      if (n <= 9L) {
        rn <- .revssConst$bnRobSclKL[n]
      } else {
        rn <- n / (n - .revssConst$bnRobSclKL[10L])
      }
    } else {
      if (n <= 9L) {
        rn <- .revssConst$bnRobScl[n]
      } else {
        rn <- n / (n - .revssConst$bnRobScl[10L])
      }
    }
  }

  rn * rS
}
