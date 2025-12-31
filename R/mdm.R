# Copyright (c) 2025, Avraham Adler All rights reserved
# SPDX-License-Identifier: BSD-2-Clause

# Median Deviation from the Median with bias correction based on Croux &
# Rousseeuw (1992).
# https://wis.kuleuven.be/stat/robust/papers/publications-1992/crouxrousseeuw-timeeffalgosnqn-compstat-1992.pdf nolint line_length_linter
# Can replace 'mad' in stats for small samples.

mdm <- function(x, na.rm = FALSE) {
  if (na.rm) x <- x[!is.na(x)]
  n <- length(x)
  if (n <= 1) {
    stop("There needs to be at least two values for a robust median.")
  }
  # See the paper for the source of these values
  bn <- switch(as.character(n),
               "2" = 1.196,
               "3" = 1.495,
               "4" = 1.363,
               "5" = 1.206,
               "6" = 1.2,
               "7" = 1.14,
               "8" = 1.129,
               "9" = 1.107,
               n / (n - 0.8)
  )

  bn * mad(x)

}
