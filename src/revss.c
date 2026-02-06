// Copyright Avraham Adler (c) 2026
// SPDX-License-Identifier: BSD-2-Clause

#include <Rmath.h>
#include "revss.h"
#include "revss_fortran.h"

SEXP median_c (SEXP x) {
  const int nx = LENGTH(x);
  SEXP ret = PROTECT(allocVector(REALSXP, 1));
  median_f_(REAL(x), nx, REAL(ret));
  UNPROTECT(1);
  return(ret);
}

SEXP adm_c (SEXP x, SEXP ct_, SEXP co_) {
  const int nx = LENGTH(x);
  SEXP ret = PROTECT(allocVector(REALSXP, 1));
  adm_f_(REAL(x), nx, REAL(ct_), REAL(co_), REAL(ret));
  UNPROTECT(1);
  return(ret);
}

SEXP mad_c (SEXP x, SEXP ct_, SEXP co_) {
  const int nx = LENGTH(x);
  SEXP ret = PROTECT(allocVector(REALSXP, 1));
  mad_f_(REAL(x), nx, REAL(ct_), REAL(co_), REAL(ret));
  UNPROTECT(1);
  return(ret);
}

SEXP robLoc_c (SEXP x, SEXP t_, SEXP s_, SEXP maxit_, SEXP tol_) {
  const int nx = LENGTH(x);
  SEXP ret = PROTECT(allocVector(REALSXP, 1));
  robLoc_f_(REAL(x), nx, REAL(t_), REAL(s_), INTEGER(maxit_), REAL(tol_),
            REAL(ret));
  UNPROTECT(1);
  return(ret);
}

SEXP robScale_c (SEXP x, SEXP t_, SEXP s_, SEXP maxit_, SEXP tol_) {
  const int nx = LENGTH(x);
  SEXP ret = PROTECT(allocVector(REALSXP, 1));
  robScale_f_(REAL(x), nx, REAL(t_), REAL(s_), INTEGER(maxit_), REAL(tol_),
              REAL(ret));
  UNPROTECT(1);
  return(ret);
}
