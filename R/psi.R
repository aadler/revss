# Copyright (c) 2026, Avraham Adler All rights reserved
# SPDX-License-Identifier: BSD-2-Clause

# Internal function.

# rho function for robLoc and robScale. Testing shows that using expm1 instead
# of plogis can be twice as fast.
# (AA: 2026-01-04)

# psi <- function(x) {
#   # When x large, logit returns 1.
#   xx <- expm1(pmin.int(x, 100))
#   xx / (xx + 2)
# }

# Profiling shows psi/plogis as a bottlneck, so ported to C.
psi <- function(x) {
  .Call(psi_c, as.double(x))
}
