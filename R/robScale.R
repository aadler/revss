# Copyright (c) 2020, Avraham Adler All rights reserved
# SPDX-License-Identifier: BSD-2-Clause

# Robust Scale Estimator found in Rousseeuw & Verboven (2002)

robScale <- function(x, loc = NULL, implbound = 1e-4, na.rm = FALSE,
                     maxit = 80L, tol = NULL, madfctrs = c("AA", "CR"),
                     usefctrs = FALSE) {

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

  if (is.null(tol)) {
    tol <- .revssConst$stdTol
  } else {
    tol <- as.double(tol)[1L]
  }

  madfctrs <- madfctrs[1L]
  isCR <- madfctrs == "CR"
  if (!isCR && madfctrs != "AA") {
    stop("madfctrs must be 'AA' or 'CR'", call. = FALSE)
  }

  if (!is.null(loc)) {
    x <- x - loc
    s <- 1.4826 * .Call(median_c, abs(x)) # MDZ in paper. Already protected
    t <- 0                        # nolint object_overwrite_linter
    minobs <- 3L
  } else {
    s <- madn(x, factors = madfctrs)
    t <- .Call(median_c, x)   # nolint object_overwrite_linter Already protected
    minobs <- 4L
  }

  if (n < minobs) {
    m <- madn(x, factors = madfctrs)
    return(if (m <= implbound) admn(x) else m)
  }

  rS <- .Call(robScale_c, x, t, s, as.integer(maxit), tol)

  if (usefctrs && is.null(loc)) {
    if (n <= 9L) {
      rn <- .revssConst$robScaleF[n]
    } else {
      rn <- n / (n - 1.126)
    }
  } else {
    rn <- 1
  }

  rn * rS
}
