# Copyright (c) 2026, Avraham Adler All rights reserved
# SPDX-License-Identifier: BSD-2-Clause

# This tests the median-of-three calls.

nS <- getNamespace("revss")
medianC <- get("median_c", nS, inherits = FALSE, mode = "list")
expect_identical(.Call(medianC, as.double(sample.int(101, 101))), 51)
