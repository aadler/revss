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
    tol <- sqrt(.Machine$double.eps)
  } else {
    tol <- as.double(tol)
  }

  if (missing(madfctrs)) {
    madfctrs <- "AA"
  } else {
    madfctrs <- match.arg(madfctrs)
  }

  madfctrs <- madfctrs[1L]
  isCR <- madfctrs == "CR"
  if (!isCR && madfctrs != "AA") {
    stop("madfctrs must be 'AA' or 'CR'", call. = FALSE)
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
