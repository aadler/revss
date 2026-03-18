# Copyright (c) 2026, Avraham Adler All rights reserved
# SPDX-License-Identifier: BSD-2-Clause

# Non-CR factor values (2:9) based on 200M simulation Monte-Carlo study.
# Asymptotic values (n > 9) based on 16.5M simulation Monte-Carlo study.
# All MCSE < 1e-4

.revssConst <- local({
  list(
       anMADM = c(NA_real_,        # MADM
                  1.4142,
                  1.2248,
                  1.1547,
                  1.1180,
                  1.0954,
                  1.0802,
                  1.0690,
                  1.0607,
                  0.5074),
       anMADMd = c(NA_real_,       # MADMd (ADM)
                   1.4142,
                   1.4142,
                   1.2031,
                   1.2031,
                   1.1342,
                   1.1342,
                   1.1001,
                   1.1001,
                   0.7558),
       bnMdADM = c(NA_real_,       # MdADM
                   1.1955,
                   0.9429,
                   1.0170,
                   1.0750,
                   1.0311,
                   1.0211,
                   1.0195,
                   1.0247,
                   0.1786),
       bnMdADMdCR = c(NA_real_,    # MdADMd (MAD) CR
                      1.196,
                      1.495,
                      1.363,
                      1.206,
                      1.200,
                      1.140,
                      1.129,
                      1.107,
                      0.8),
       bnMdADMdAA = c(NA_real_,    # MdADMd (MAD) AA
                      1.1955,
                      1.4872,
                      1.3606,
                      1.2167,
                      1.1896,
                      1.1380,
                      1.1274,
                      1.1012,
                      0.7852),
       bnRobScl = c(NA_real_,
                    NA_real_,      # Should never be called
                    NA_real_,      # Should never be called
                    1.3082,
                    1.3190,
                    1.2160,
                    1.2024,
                    1.1605,
                    1.1477,
                    1.1256),
       bnRobSclKL = c(NA_real_,
                      NA_real_,    # Should never be called
                      0.9401,
                      0.9547,
                      0.9639,
                      0.9696,
                      0.9741,
                      0.9773,
                      0.9798,
                      -0.1851),
       stdTol = sqrt(.Machine$double.eps),
       sqrthalfpi = 1.2533141373155001
  )
})
