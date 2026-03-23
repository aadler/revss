# Copyright (c) 2020, Avraham Adler All rights reserved
# SPDX-License-Identifier: BSD-2-Clause

tol <- sqrt(.Machine$double.eps)

# Bias Factors
bnRobScl4 <- 1.3082
bnRobSclL <- 1.1256
bnRobSclKL6 <- 0.9696
bnRobSclKLL <- -0.1851
MdASMd3AA <- 1.4872 # nolint object_name_linter
MdASMd3CR <- 1.495  # nolint object_name_linter

## Generate Test Data
eff_seed <- sample.int(65536, 1)
set.seed(eff_seed)
y <- c(9, 2, 14, 4)
vSmall <- c(0, 1e-7, 1e-5)
factErr <- "must be 'AA' or 'CR'"

## RobScale Tests
psif <- function(x) {
  y <- expm1(pmin.int(x / 0.37394112142347236, 100))
  (y / (y + 2)) ^ 2
}

robScaleTest <- function(x, mi = 80L, tol = NULL) {
  if (is.null(tol)) tol <- sqrt(.Machine$double.eps)
  t <- median(x) # nolint object_overwrite_linter
  s <- revss::madn(x)
  i <- 0
  v <- 2
  while (abs(v - 1) >= tol && (i <= mi)) {
    i <- i + 1
    v <- sqrt(2 * mean(psif((x - t) / s)))
    s <- s * v
  }

  s
}

expect_equal(robScale(y, opts = list(usefctrs = FALSE)), robScaleTest(y),
             tolerance = tol)
expect_equivalent(robScale(y, opts = list(usefctrs = FALSE,
                                          tol = 100 * .Machine$double.eps)),
                  robScaleTest(y, tol = 100 * .Machine$double.eps),
                  tolerance = 100 * .Machine$double.eps)
expect_equal(robScale(y), bnRobScl4 * robScaleTest(y), tolerance = tol)

# Test "minobs" Handling
expect_equal(robScale(y[1:3]), madn(y[1:3]), tolerance = tol)
expect_equal(robScale(c(1e-5, 0, 4)), admn(c(1e-5, 0, 4)), tolerance = tol)
expect_equal(robScale(c(0.0001, 0, 4)), madn(c(0.0001, 0, 4)), tolerance = tol)

# Test Exception Handling
expect_true(is.na(robScale(double(0))))
expect_true(is.na(robScale(c(NA, NA), na.rm = TRUE)))
expect_error(robScale(1:5, opts = list(madfctrs = "ZZ")), factErr)

# Test passing factors which only matters for length(x) < minobs
expect_equal(robScale(y[1:3], opts = list(madfctrs = "AA")),
             robScale(y[1:3]), tolerance = tol)
expect_false(isTRUE(all.equal(robScale(y[1:3], opts = list(madfctrs = "CR")),
                              robScale(y[1:3]), tolerance = tol)))
expect_equal(robScale(y[1:3], opts = list(madfctrs = "CR")),
             robScale(y[1:3]) * MdASMd3CR / MdASMd3AA, tolerance = tol)

# Test other options
expect_equal(robScale(y, opts = list(maxit = 1000L)), robScale(y),
             tolerance = tol)
expect_equal(robScale(vSmall), admn(vSmall), tolerance = tol)
expect_equal(robScale(vSmall, opts = list(implbound = 1e-9)),
             madn(vSmall), tolerance = tol)

# Excel precision probably lacking here.
expect_equal(robScale(c(1e-4, 0, 0, 4), opts = list(usefctrs = FALSE)),
             0.0001015301155129359, tolerance = 1e-7)
expect_equal(robScale(c(1L, 0L, 3L, 5L)),
             robScale(c(1, 0, 3, 5)),
             tolerance = tol)
expect_equal(robScale(3:21),
             robScale(3:21, opts = list(usefctrs = FALSE)) *
               19 / (19 - bnRobSclL), tolerance = tol)

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
expect_equal(robScale(y, loc = 7, opts = list(usefctrs = FALSE)),
             robScaleLocTest(y, loc = 7), tolerance = tol)
expect_equal(robScale(1:3, loc = 3, opts = list(usefctrs = FALSE)),
             robScaleLocTest(1:3, loc = 3), tolerance = tol)
expect_false(isTRUE(all.equal(robScale(1:3, opts = list(usefctrs = FALSE)),
                              robScaleLocTest(1:3, loc = 0))))
z <- rnorm(6) + 1
expect_equal(robScale(z, loc = 1),
             robScale(z, loc = 1, opts = list(usefctrs = FALSE)) * bnRobSclKL6,
             tolerance = tol)
z <- rnorm(12) + 3
expect_equal(robScale(z, loc = 3),
             robScale(z, loc = 3, opts = list(usefctrs = FALSE)) *
               12 / (12 - bnRobSclKLL), tolerance = tol)

# Test Error Trapping
expect_true(is.na(robScale(c(y, NA))))
expect_true(is.na(suppressWarnings(robScale(c(y, "A")))))
expect_equal(robScale(c(y, NA), na.rm = TRUE), robScale(y), tolerance = tol)

message("\nSeed for robScale test session: ", eff_seed)
