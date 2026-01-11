// Copyright Avraham Adler (c) 2026
// SPDX-License-Identifier: BSD-2-Clause

#include <Rmath.h>
#include "revss.h"

void F77_NAME(median_f)(double *x, int nx, double *ret);

extern SEXP median_c (SEXP x) {
  const int nx = LENGTH(x);
  SEXP ret = PROTECT(allocVector(REALSXP, 1));
  F77_CALL(median_f)(REAL(x), nx, REAL(ret));
  UNPROTECT(1);
  return(ret);
}

void F77_NAME(adm_f)(double *x, int nx, double *ct, double *co, double *ret);

extern SEXP adm_c (SEXP x, SEXP ct_, SEXP co_) {
  const int nx = LENGTH(x);
  SEXP ret = PROTECT(allocVector(REALSXP, 1));
  F77_CALL(adm_f)(REAL(x), nx, REAL(ct_), REAL(co_), REAL(ret));
  UNPROTECT(1);
  return(ret);
}

void F77_NAME(mad_f)(double *x, int nx, double *ct, double *co, double *ret);

extern SEXP mad_c (SEXP x, SEXP ct_, SEXP co_) {
  const int nx = LENGTH(x);
  SEXP ret = PROTECT(allocVector(REALSXP, 1));
  F77_CALL(mad_f)(REAL(x), nx, REAL(ct_), REAL(co_), REAL(ret));
  UNPROTECT(1);
  return(ret);
}

void F77_NAME(robLoc_f)(double *x, int nx, double *t, double *s, int *maxit,
              double *tol, double *ret);

extern SEXP robLoc_c (SEXP x, SEXP t_, SEXP s_, SEXP maxit_, SEXP tol_) {
  const int nx = LENGTH(x);
  SEXP ret = PROTECT(allocVector(REALSXP, 1));
  F77_CALL(robLoc_f)(REAL(x), nx, REAL(t_), REAL(s_), INTEGER(maxit_),
           REAL(tol_), REAL(ret));
  UNPROTECT(1);
  return(ret);
}

void F77_NAME(robScale_f)(double *x, int nx, double *t, double *s, int *maxit,
              double *tol, double *ret);

extern SEXP robScale_c (SEXP x, SEXP t_, SEXP s_, SEXP maxit_, SEXP tol_) {
  const int nx = LENGTH(x);
  SEXP ret = PROTECT(allocVector(REALSXP, 1));
  F77_CALL(robScale_f)(REAL(x), nx, REAL(t_), REAL(s_), INTEGER(maxit_),
           REAL(tol_), REAL(ret));
  UNPROTECT(1);
  return(ret);
}
