// Copyright Avraham Adler (c) 2026
// SPDX-License-Identifier: BSD-2-Clause

#include <Rmath.h>

#include "revss.h"

double psi(double x) {
  double y = expm1(fmin2(x, 100.0));
  return(y / (y + 2.0));
}

extern SEXP robLoc_c (SEXP x, SEXP t_, SEXP s_, SEXP maxit_, SEXP tol_) {
  const R_xlen_t n = xlength(x);
  double *px = REAL(x);

  const double s = Rf_asReal(s_);
  const double tol = Rf_asReal(tol_);
  const int maxit = Rf_asInteger(maxit_);
  const double bt = 0.413241928283814;

  double t = Rf_asReal(t_);
  double v = 1000.0 * tol;
  int k = 0;

  SEXP ret = PROTECT(allocVector(REALSXP, 1));
  double *pret = REAL(ret);
  Memzero(pret, 1);

  while (fabs(v) > tol && k < maxit) {
    ++k;
    double xx = 0.0;
    for (R_xlen_t i = 0; i < n; ++i) {
      xx += psi((px[i] - t) / s);
    }
    xx /= (bt * (double)n);
    v = s * xx;
    t += v;
  }

  pret[0] = t;
  UNPROTECT(1);
  return(ret);
}

extern SEXP robScale_c (SEXP x, SEXP t_, SEXP s_, SEXP maxit_, SEXP tol_) {
  const R_xlen_t n = xlength(x);
  double *px = REAL(x);

  const double t = Rf_asReal(t_);
  const double tol = Rf_asReal(tol_);
  const int maxit = Rf_asInteger(maxit_);
  const double bt = 0.37394112142347236;

  double s = Rf_asReal(s_);
  double v = 2.0 + tol;
  int k = 0;

  SEXP ret = PROTECT(allocVector(REALSXP, 1));
  double *pret = REAL(ret);
  Memzero(pret, 1);

  while (fabs(v - 1.0) > tol && k < maxit) {
    ++k;
    double xx = 0.0;
    for (R_xlen_t i = 0; i < n; ++i) {
      xx += R_pow_di(psi((px[i] - t) / (s * bt)), 2);
    }
    xx /= (double)n;
    v = sqrt(2.0 * xx);
    s *= v;
  }

  pret[0] = s;

  UNPROTECT(1);
  return(ret);

}
