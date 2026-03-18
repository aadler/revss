# Copyright (c) 2026, Avraham Adler All rights reserved
# SPDX-License-Identifier: BSD-2-Clause

# This tests the median-of-three calls.
expect_identical(.Call(revss:::median_c, as.double(sample.int(101, 101))), 51)
