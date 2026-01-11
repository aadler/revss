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

# ADM
## Mean Absolute Deviation from the Median
expect_equal(adm(x5), adm5 * sqrt(pi / 2), tolerance = tol)
expect_equal(adm(c(x5, NA), na.rm = TRUE), adm5 * sqrt(pi / 2), tolerance = tol)
expect_equal(adm(x5, constant = 1), adm5, tolerance = tol)
expect_equal(adm(c(x5, NA), constant = 1, na.rm = TRUE), adm5, tolerance = tol)
expect_true(is.na(adm(c(x5, NA))))
expect_true(is.na(adm(c(x5, NA), constant = 1)))

## Mean Absolute Deviation from the Mean
expect_equal(adm(x5, center = mean(x5)),
             sqrt(pi / 2) * mean(abs(x5 - mean(x5))),
             tolerance = tol)

## Error Trapping
expect_error(adm(4), oneValErr)
# expect_warning(adm(c(x5, "c"))) No warning for own adm; the error is enough.
expect_error(suppressWarnings(adm(c(x5, "c"))), "non-numeric argument")
expect_true(is.na(adm(c(x5, NA))))     # mad returns NA here too.


# ADMN
## Mean Absolute Deviation from the Mean
expect_equal(admn(x5, center = "mean"),
             adm(x5, center = mean(x5)) * 1.11763,
             tolerance = tol)

## Mean Absolute Deviation from the Median
expect_equal(admn(x5, center = "median"),
             adm(x5, center = median(x5)) * 1.20265,
             tolerance = tol)

expect_error(admn(4), oneValErr)
expect_equal(admn(c(x5, NA), na.rm = TRUE), admn(x5), tolerance = tol)
expect_true(is.na(admn(c(x5, NA))))                  # mad returns NA here too.
# expect_warning(admn(c(x5, "c"))) No warning for own adm; the error is enough.
expect_error(suppressWarnings(admn(c(x5, "c"))), "non-numeric argument")

message("Seed for adm test session: ", eff_seed)
