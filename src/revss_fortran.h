// Copyright Avraham Adler (c) 2026
// SPDX-License-Identifier: BSD-2-Clause

#ifndef revss_Fortran_H
#define revss_Fortran_H

extern void median_f_(double *x, int nx, double *ret);
extern void adm_f_(double *x, int nx, double *ct, double *co, double *ret);
extern void mad_f_(double *x, int nx, double *ct, double *co, double *ret);
extern void robLoc_f_(double *x, int nx, double *t, double *s, int *maxit,
                      double *tol, double *ret);
extern void robScale_f_(double *x, int nx, double *t, double *s, int *maxit,
                        double *tol, double *ret);

#endif
