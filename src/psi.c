// Copyright Avraham Adler (c) 2026
// SPDX-License-Identifier: BSD-2-Clause

#include <R.h>
#include <Rinternals.h>
#include <Rmath.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

double psi(double x) {
  double y = expm1(fmin2(x, 100.0));
  return(y / (y + 2.0));
}

extern SEXP psi_c(SEXP x) {
  const R_xlen_t n = xlength(x);
  double *px = REAL(x);

  SEXP ret = PROTECT(allocVector(REALSXP, n));
  double *pret = REAL(ret);
  Memzero(pret, n);

  for (R_xlen_t i = 0; i < n; ++i) {
    pret[i] = psi(px[i]);
  }

  UNPROTECT(1);
  return(ret);
}

extern SEXP psisq_c(SEXP x) {
  const R_xlen_t n = xlength(x);
  double *px = REAL(x);

  SEXP ret = PROTECT(allocVector(REALSXP, n));
  double *pret = REAL(ret);
  Memzero(pret, n);

  for (R_xlen_t i = 0; i < n; ++i) {
    pret[i] = R_pow_di(psi(px[i]), 2);
  }

  UNPROTECT(1);
  return(ret);
}

static const R_CallMethodDef CallEntries[] = {
  {"psi_c",     (DL_FUNC) &psi_c,   1},
  {"psisq_c",   (DL_FUNC) &psisq_c, 1},
  {NULL,        NULL,               0}
};

void R_init_revss(DllInfo *dll) {
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
  R_forceSymbols(dll, TRUE);
}
