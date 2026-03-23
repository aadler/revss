# Copyright (c) 2020, Avraham Adler All rights reserved
# SPDX-License-Identifier: BSD-2-Clause

tol <- sqrt(.Machine$double.eps)

## Generate Test Data
eff_seed <- sample.int(65536, 1)
set.seed(eff_seed)
x5 <- runif(5, 0, 100)
y <- c(9, 2, 14, 4)
lZero <- double(0)
factErr <- "must be 'AA' or 'CR'"

## RobLoc Tests
robLocTest <- function(x, na.rm = FALSE, tol = sqrt(.Machine$double.eps)) {
  if (na.rm) {
    x <- x[!is.na(x)]
  }
  if (length(x) <= 3) {
    return(median(x))
  } else {
    obj <- function(x, data) {
      sum((2 * plogis((data - x) / madn(data)) - 1)) ^ 2
    }
    fit <- optimize(f = obj, interval = range(x), data = x, tol = tol)
    return(fit$minimum)
  }
}

robLocScaleTest <- function(x, scale, na.rm = FALSE,
                            tol = sqrt(.Machine$double.eps)) {
  if (na.rm) {
    x <- x[!is.na(x)]
  }
  if (length(x) <= 2) {
    return(median(x))
  } else {
    obj <- function(x, data) {
      sum((2 * plogis((data - x) / scale) - 1)) ^ 2
    }
    fit <- optimize(f = obj, interval = range(x), data = x, tol = tol)
    return(fit$minimum)
  }
}

expect_equal(robLoc(x5), robLocTest(x5), tolerance = tol)
expect_equal(robLoc(x5), robLoc(x5, opts = list(maxit = 100L)), tolerance = tol)
expect_equal(robLoc(x5, opts = list(tol = .Machine$double.eps)),
             robLocTest(x5, .Machine$double.eps), tolerance = tol)
expect_equal(robLoc(c(1, 9, 7)), median(c(1, 9, 7)), tolerance = tol)
expect_equal(robLoc(x5, factors = "AA"), robLoc(x5), tolerance = tol)
expect_false(isTRUE(all.equal(robLoc(x5, factors = "CR"),
                              robLoc(x5), tolerance = tol)))

# Known Scale
expect_equal(robLoc(y, scale = 5), robLocScaleTest(y, scale = 5),
             tolerance = tol)
expect_equal(robLoc(c(1, 8, 12), scale = 5),
             robLocScaleTest(c(1, 8, 12), scale = 5), tolerance = tol)
expect_equal(robLoc(c(1, 8), scale = 5), median(c(1, 8)), tolerance = tol)
expect_false(isTRUE(all.equal(robLoc(c(1, 8, 12), scale = 5),
                              median(c(1, 8, 12)))))

# Integer conversion
expect_equal(robLoc(c(5L, 8L, 19L)), robLoc(c(5, 8, 19)), tolerance = tol)

# RobLoc Error Trapping
expect_true(is.na(robLoc(c(x5, NA))))
expect_true(is.na(suppressWarnings(robLoc(c(x5, "A")))))
expect_equal(robLoc(c(x5, NA), na.rm = TRUE), robLoc(x5), tolerance = tol)
expect_true(is.na(robLoc(lZero)))
expect_true(is.na(robLoc(c(NA, NA), na.rm = TRUE)))
expect_error(robLoc(1:5, factors = "ZZ"), factErr)

message("\nSeed for robLoc test session: ", eff_seed)
