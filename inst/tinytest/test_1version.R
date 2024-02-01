# Copyright Avraham Adler (c) 2023
# SPDX-License-Identifier: MPL-2.0+

pV <- packageVersion("revss")

# Test CITATION has most recent package version
expect_true(any(grepl(pV, toBibtex(citation("revss")), fixed = TRUE)))

# Test NEWS has most recent package version
expect_true(any(grepl(pV, news(package = "revss"), fixed = TRUE)))

# Test that NEWS has an entry with DESCRIPTION's Date
expect_true(any(grepl(packageDate("revss"),
                      news(package = "revss"), fixed = TRUE)))
