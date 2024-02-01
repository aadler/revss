---
title: Security
---
# Security
## Expectations
This package is a calculation engine and requires no secrets or private
information. It is checked for memory leaks prior to releases to CRAN using
ASAN/UBSAN. Dissemination is handled by CRAN. Bugs are reported via the tracker
and handled as soon as possible.

## Assurance
The threat model is that a malicious actor would "poison" the package code by
adding in elements having nothing to do with the package's purpose but which
would be used for malicious purposes. This is protected against by having the
email account of the maintainer—used for verification by CRAN—protected by a
physical 2FA device (Yubikey) which is carried by the lead maintainer.
