# Copyright (c) 2020, Avraham Adler All rights reserved
# SPDX-License-Identifier: BSD-2-Clause

# Average Deviation from the Median with bias correction. Patterned after 'mad'
# in stats

adm <- function(x, center = median(x), constant = sqrt(pi / 2), na.rm = FALSE) {
  if (na.rm) {
    x <- x[!is.na(x)]
  }
  constant * mean(abs(x - center))
}
