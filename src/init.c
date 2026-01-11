// Copyright Avraham Adler (c) 2026
// SPDX-License-Identifier: BSD-2-Clause

#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>
#include "revss.h"

static const R_CallMethodDef CallEntries[] = {
  {"adm_c",       (DL_FUNC) &adm_c,      3},
  {"robLoc_c",    (DL_FUNC) &robLoc_c,   5},
  {"robScale_c",  (DL_FUNC) &robScale_c, 5},
  {NULL,          NULL,                  0}
};

void R_init_revss(DllInfo *dll) {
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
  R_forceSymbols(dll, TRUE);
}
