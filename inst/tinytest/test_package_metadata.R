# Copyright Avraham Adler (c) 2023
# SPDX-License-Identifier: MPL-2.0+

# Only test at home. rhub valgrind complains and it should not affect covr.

if (Sys.info()["nodename"] == "HOME") {

  # Setup
  myPkgs <- c("Delaporte",
              "lamW",
              "Pade",
              "revss",
              "minimaxApprox",
              "MBBEFDLite")
  thisPkg <- "revss"
  otrPkgs <- setdiff(myPkgs, thisPkg)

  # Universal code
  pV <- packageVersion(thisPkg)
  pD <- packageDate(thisPkg)
  cit <- toBibtex(citation(thisPkg))
  nws <- news(package = thisPkg)

  # Test CITATION has most recent package version
  expect_true(any(grepl(pV, cit), fixed = TRUE))

  # Test NEWS has most recent package version
  expect_true(any(grepl(pV, nws, fixed = TRUE)))

  # Test that NEWS has an entry with DESCRIPTION's Date
  expect_true(any(grepl(pD, nws, fixed = TRUE)))

  # Test that CITATION doesn't contain the name of any other of my packages
  expect_false(any(sapply(otrPkgs, grepl, x = cit, fixed = TRUE)))

  # Test that NEWS doesn't contain the name of any other of my packages
  expect_false(any(sapply(otrPkgs, grepl, x = nws, fixed = TRUE)))
}
