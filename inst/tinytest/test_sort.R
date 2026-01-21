# Copyright (c) 2026, Avraham Adler All rights reserved
# SPDX-License-Identifier: BSD-2-Clause

A <- c(2, 3, 4, 5, 7)
B <- c(7, 2, 4, 3, 5)
C <- sample.int(101, 101)
expect_identical(revss:::medianR(A), 4)
expect_identical(revss:::medianR(B), 4)
expect_identical(revss:::medianR(C), 51)
