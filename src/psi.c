// Copyright Avraham Adler (c) 2026
// SPDX-License-Identifier: BSD-2-Clause

#include <R.h>
#include <Rinternals.h>
#include <Rmath.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

extern SEXP psi_c(SEXP x) {
  const R_xlen_t n = xlength(x);
  double *px = REAL(x);

  SEXP ret = PROTECT(allocVector(REALSXP, n));
  double *pret = REAL(ret);
  Memzero(pret, n);

  for (R_xlen_t i = 0; i < n; ++i) {
    double y = expm1(fmin2(px[i], 100.0));
    pret[i] = y / (y + 2.0);
  }

  UNPROTECT(1);
  return(ret);
}

static const R_CallMethodDef CallEntries[] = {
  {"psi_c",     (DL_FUNC) &psi_c,   1},
  {NULL,        NULL,               0}
};

void R_init_revss(DllInfo *dll) {
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
  R_forceSymbols(dll, TRUE);
}
