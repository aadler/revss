// Copyright Avraham Adler (c) 2026
// SPDX-License-Identifier: BSD-2-Clause

#ifndef revss_H
#define revss_H

#include <R.h>
#include <Rinternals.h>

extern SEXP robLoc_c (SEXP x, SEXP t_, SEXP s_, SEXP maxit_, SEXP tol_);
extern SEXP robScale_c (SEXP x, SEXP t_, SEXP s_, SEXP maxit_, SEXP tol_);

#endif
