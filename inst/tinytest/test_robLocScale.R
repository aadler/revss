# Copyright (c) 2020, Avraham Adler All rights reserved
# SPDX-License-Identifier: BSD-2-Clause

tol <- sqrt(.Machine$double.eps)

## Generate Test Data
eff_seed <- sample.int(65536, 1)
set.seed(eff_seed)
x5 <- runif(5, 0, 100)
t5 <- median(x5)
adm5 <- mean(abs(x5 - t5))
mad5 <- median(abs(x5 - t5))
y <- c(9, 2, 14, 4)
naErr <- "There are NAs in the data yet na.rm is FALSE"
oneValErr <- "There needs to be at least two values for a robust measure."
numErr <- "x contains non-numeric entries."

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
expect_equal(robLoc(x5, tol = .Machine$double.eps),
             robLocTest(x5, .Machine$double.eps), tolerance = tol)
expect_equal(robLoc(c(1, 9, 7)), median(c(1, 9, 7)), tolerance = tol)

expect_equal(robLoc(x5, factors = "AA"), robLoc(x5), tolerance = tol)
expect_false(isTRUE(all.equal(robLoc(x5, factors = "CR"),
                              robLoc(x5),
                              tolerance = tol)))

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
expect_error(robLoc(c(x5, NA)), pattern = naErr)
expect_equal(robLoc(c(x5, NA), na.rm = TRUE), robLoc(x5), tolerance = tol)
expect_error(robLoc(c(x5, "A")), pattern = numErr)

## RobScale Tests
expect_equal(robScale(y), 5.8798344696311284, tolerance = tol)

# Test Exception Handling
expect_equal(robScale(y[1:3]), madn(y[1:3]), tolerance = tol)
expect_equal(robScale(c(1e-5, 0, 4)), admn(c(1e-5, 0, 4)), tolerance = tol)
expect_equal(robScale(c(0.0001, 0, 4)), madn(c(0.0001, 0, 4)), tolerance = tol)

# Test passing factors which only matters for length(x) < minobs
expect_equal(robScale(y[1:3], factors = "AA"),
             robScale(y[1:3]),
             tolerance = tol)
expect_false(isTRUE(all.equal(robScale(y[1:3], factors = "CR"),
                       robScale(y[1:3]),
                       tolerance = tol)))

# Excel precision probably lacking here.
expect_equal(robScale(c(1e-4, 0, 0, 4)), 0.0001015301155129359,
             tolerance = 1e-7)
expect_equal(robScale(c(1L, 0L, 3L, 5L)),
             robScale(c(1, 0, 3, 5)),
             tolerance = tol)

robScaleLocTest <- function(x, loc) {
  x <- x - loc
  s <- 1.4826 * median(abs(x))
  converged <- FALSE
  k <- 0
  while (!converged && k < 80) {
    k <- k + 1
    v <- sqrt(2 * mean((2 * plogis(x / (s * 0.37394112142347236)) - 1) ^ 2))
    converged <- abs(v - 1) <= sqrt(.Machine$double.eps)
    s <- s * v
  }
  return(s)
}

# Test Known Location
expect_equal(robScale(y, loc = 7), robScaleLocTest(y, loc = 7), tolerance = tol)
expect_equal(robScale(1:3, loc = 3), robScaleLocTest(1:3, loc = 3),
             tolerance = tol)
expect_false(isTRUE(all.equal(robScale(1:3), robScaleLocTest(1:3, loc = 0))))
expect_equal(robScale(1:3), madn(1:3), tolerance = tol)

# Test Error Trapping
expect_error(robScale(c(x5, NA)), pattern = naErr)
expect_equal(robScale(c(x5, NA), na.rm = TRUE), robScale(x5), tolerance = tol)
expect_error(robScale(c(x5, "A")), pattern = numErr)

message("Seed for robLocScale test session: ", eff_seed)
