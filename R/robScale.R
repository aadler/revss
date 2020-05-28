# Robust Scale Estimator found in Rousseeuw & Verboven (2002)

robScale <- function(x, loc = NULL, implbound = 1e-4, na.rm = FALSE, maxit = 60,
                   tol = sqrt(.Machine$double.eps)) {
  if (na.rm) {
    x <- x[!is.na(x)]
  } else {
    if (anyNA(x)) {
      stop("There are NAs in the data yet na.rm is FALSE")
    }
  }
  if (!is.null(loc)) {
    x <- x - loc
    s <- 1.4826 * median(abs(x))
    t <- 0
    minobs <- 3
  } else {
    s <- mad(x)
    t <- median(x)
    minobs <- 4
  }
  if (length(x) < minobs) {
    if (mad(x) <= implbound) {
      return(adm(x))
    } else {
      return(mad(x))
    }
  } else {
    converged <- FALSE
    k <- 0
    while (!converged & k < maxit) {
      k <- k + 1
      v <- sqrt(2 * mean((2 * plogis(((x - t) / s) / 0.3739) - 1) ^ 2))
      converged <- abs(v - 1) <= tol
      s <- s * v
    }
    return(s)
  }
}
