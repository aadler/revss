# Robust Location Estimator found in Rousseeuw & Verboven (2002)

robLoc <- function(x, scale = NULL, na.rm = FALSE, maxit = 60,
                   tol = sqrt(.Machine$double.eps)) {
  if (na.rm) {
    x <- x[!is.na(x)]
  } else {
    if (anyNA(x)) {
      stop("There are NAs in the data yet na.rm is FALSE")
    }
  }
  if (!is.null(scale)) {
    minobs <- 3
    s <- scale
  } else {
    minobs <- 4
    s <- mad(x)
  }
  if (length(x) < minobs) {
    return(median(x))
  } else {
    t <- median(x)
    converged <- FALSE
    k <- 0
    while (!converged & k < maxit) {
      k <- k + 1
      v <- s * mean((2 * plogis((x - t) / s) - 1) / 0.413241928283814)
      converged <- abs(v) <= tol
      t <- t + v
    }
    return(t)
  }
}
