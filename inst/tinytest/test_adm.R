# Copyright (c) 2025, Avraham Adler All rights reserved
# SPDX-License-Identifier: BSD-2-Clause

tol <- sqrt(.Machine$double.eps)

## Generate Test Data
eff_seed <- sample.int(65536, 1)
set.seed(eff_seed)
x5 <- runif(5, 0, 100)
t5 <- median(x5)
adm5 <- mean(abs(x5 - t5))
y <- c(9, 2, 14, 4)
oneValErr <- "There needs to be at least two values for a robust measure."
badCentErr <- "center must be 'median' or 'mean"
lZero <- double(0)

admTest <- function(x, ct, co = NULL) {

  if (is.null(co)) {
    co <- 1.2533141373155001 # sqrt(pi / 2)
  } else {
    co <- as.double(co)
  }

  co * mean(abs(x - ct))
}

# medianR error trapping
expect_true(is.na(revss:::medianR(lZero)))
expect_true(is.na(revss:::medianR(c(NA, NA))))
expect_true(is.na(revss:::medianR(c(NA, NA), na.rm = TRUE)))
expect_true(is.na(suppressWarnings(revss:::medianR(c(x5, "c")))))
expect_equal(revss:::medianR(c(x5, NA), na.rm = TRUE),
             revss:::medianR(x5), tolerance = tol)
expect_identical(revss:::medianR(c(4, 5, 3)), 4) # Catch all pivots

# ADM
## Mean Absolute Deviation from the Median
expect_equal(adm(x5), adm5 * sqrt(pi / 2), tolerance = tol)
expect_equal(adm(x5), admTest(x5, revss:::medianR(x5)), tolerance = tol)
expect_equal(adm(c(x5, NA), na.rm = TRUE), adm5 * sqrt(pi / 2), tolerance = tol)
expect_equal(adm(x5, constant = 1), adm5, tolerance = tol)
expect_equal(adm(c(x5, NA), constant = 1, na.rm = TRUE), adm5, tolerance = tol)

## Mean Absolute Deviation from the Mean
expect_equal(adm(x5, center = mean(x5)),
             sqrt(pi / 2) * mean(abs(x5 - mean(x5))),
             tolerance = tol)
expect_equal(adm(x5, center = mean(x5)),
             admTest(x5, mean(x5)),
             tolerance = tol)

## Error Trapping
expect_error(adm(4), oneValErr)
expect_true(is.na(suppressWarnings(adm(c(x5, "c")))))
expect_true(is.na(adm(c(x5, NA))))
expect_true(is.na(adm(c(x5, NA), constant = 1)))
expect_true(is.na(adm(lZero)))
expect_true(is.na(adm(NA, na.rm = TRUE)))
expect_true(is.na(adm(1:5, center = "", na.rm = TRUE)))

# ADMN
## Mean Absolute Deviation from the Mean
expect_equal(admn(x5, center = "mean"),
             adm(x5, center = mean(x5)) * 1.11797,
             tolerance = tol)
expect_equal(admn(3:20, center = "mean"),
             adm(3:20, center = mean(3:20)) * 18 / (18 - 0.508),
             tolerance = tol)

## Mean Absolute Deviation from the Median
expect_equal(admn(x5, center = "median"),
             adm(x5, center = median(x5)) * 1.20307,
             tolerance = tol)
expect_equal(admn(3:20),
             adm(3:20, center = median(3:20)) * 18 / (18 - 0.756),
             tolerance = tol)

expect_equal(admn(3:21),
             adm(3:21, center = median(3:21)) * 18 / (18 - 0.756),
             tolerance = tol)

expect_error(admn(4), oneValErr)
expect_equal(admn(c(x5, NA), na.rm = TRUE), admn(x5), tolerance = tol)
expect_true(is.na(admn(c(x5, NA))))
expect_true(is.na(suppressWarnings(admn(c(x5, "c")))))
expect_true(is.na(admn(lZero)))
expect_true(is.na(admn(NA, na.rm = TRUE)))
expect_error(admn(1:5, center = "IQR"), badCentErr)

message("Seed for adm test session: ", eff_seed)
