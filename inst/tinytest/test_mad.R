# Copyright (c) 2025, Avraham Adler All rights reserved
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
oneValErr <- "There needs to be at least two values for a robust measure."
badCentErr <- "center must be 'median' or 'mean"
factErr <- "must be 'AA' or 'CR'"

# Bias reduction factors:
bnMdADM5 <- 1.0750
bnMdADML <- 0.1786
bnMdADMdCR4 <- 1.363
bnMdADMdCRL <- 0.8
bnMdADMdAA4 <- 1.3606
bnMdADMdAAL <- 0.7852
tstSeq <- 3:21
tstL <- length(tstSeq)
tstLE <- 2 * (tstL %/% 2)
tstM <- mean(tstSeq)

## Median Absolute Deviation from the Median Small Sample
expect_equal(madn(y, factors = "CR"), bnMdADMdCR4 * mad(y), tolerance = tol)
expect_equal(madn(y), bnMdADMdAA4 * mad(y), tolerance = tol)
expect_equal(madn(y, center = "median"),
             madn(y, factors = "AA"),
             tolerance = tol)

z <- runif(12)
expect_equal(madn(z, factors = "CR"), 12 / (12 - bnMdADMdCRL) * mad(z),
             tolerance = tol)
expect_equal(madn(z, factors = "AA"), 11 / (11 - bnMdADMdAAL) * mad(z),
             tolerance = tol)
expect_equal(madn(c(NA, z, NA), na.rm = TRUE), madn(z), tolerance = tol)

## Median Absolute Deviation from the Mean Small Sample
expect_equal(madn(x5, center = "mean", factors = "AA"),
             mad(x5, center = mean(x5)) * bnMdADM5, tolerance = tol)
expect_equal(madn(tstSeq, center = "mean"),
             mad(tstSeq, center = tstM) * tstLE / (tstLE - bnMdADML),
             tolerance = tol)

## Error trapping
expect_true(is.na(madn(c(NA, z, NA))))
expect_true(is.na(suppressWarnings(madn(c(z, "c")))))
expect_error(madn(4), oneValErr)
expect_error(madn(4, center = "mean"), oneValErr)
expect_true(is.na(madn(c(x5, NA), center = "mean")))
expect_true(is.na(suppressWarnings(madn(c(x5, "c"), center = "mean"))))
expect_warning(madn(x5, center = "mean", factors = "CR"),
               "Using Adler's factors")
expect_error(madn(1:5, center = "IQR"), badCentErr)
expect_error(madn(1:5, factors = "ZZ"), factErr)

message("\nSeed for mad test session: ", eff_seed)
