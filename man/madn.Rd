% Copyright (c) 2025, Avraham Adler All rights reserved
% SPDX-License-Identifier: BSD-2-Clause

\name{madn}
\alias{madn}
\title{
Median Absolute Deviation from the Median or Mean for Small Sample Size
}
\description{
  The median absolute deviation (\acronym{MAD}) is actually the median absolute
  deviation from the median. For small samples, the normal bias correction of
  1.4826 has been shown by Croux & Rousseeuw (1992) to be insufficient.
  This function can apply the \eqn{n}-specific \eqn{b_n} correction factors
  found in that paper. It also can apply factors found by a significantly larger
  Monte-Carlo simulation (2026) for either the median absolute distance from the
  median or from the mean.
}
\usage{
madn(x, center = c("median", "mean"), factors = c("AA", "CR"), na.rm = FALSE)
}
\arguments{
  \item{x}{\strong{numeric}; A vector of values.}
  \item{center}{\strong{character}; either \code{"median"} or \code{"mean"}
  which will be used as the function to calculate the central tendency from
  which to measure the absolute deviations. Defaults to \code{"median"}.}
  \item{factors}{\strong{character}; \code{"CR"} will use the factors calculated
  in Croux & Rousseeuw (1992) while \code{"AA"} (the default) will use the
  factors calculated by the package author (2026). Note that if
  \code{center == "mean"}, there are no \code{CR} factors and the \code{AA}
  factors will be used.}
  \item{na.rm}{\strong{logical}; If \code{TRUE} then \code{NA} values are
  stripped from \code{x} before computation takes place.}
}
\details{
 \deqn{MAD_n = b_n\;1.4826\;\underset{i}{\textrm{med}}\;|x_i -
 \underset{j}{\textrm{center}}\;x_j|}{MADn = b_n * 1.4826 * median(abs(x -
 center(x)))}

 where \eqn{b_n} is calculated either by Croux & Rousseeuw (1992) or by
 Adler (2026) and \code{center} is either \code{median} or \code{mean}.

 Croux & Rousseeuw (1992) used Monte-Carlo methods to calculate correction
 factors to make the standard \acronym{MAD} estimate more unbiased for small
 samples. They called this new function \eqn{\textrm{MAD}_n} to differentiate it
 from \eqn{\textrm{MAD}}, given the \eqn{b_n} multiplier is dependent on
 \eqn{n}---the size of the sample.

 Inspired by Croux & Rousseeuw, the package author (2026) ran a significantly
 larger Monte-Carlo simulation for both the median absolute deviation from the
 median and the median absolute deviation from the mean. This function uses
 those factors as default.

 However, unlike \code{mad}, this function only accepts \code{"median"} or
 \code{"mean"} as its central tendency---not a scalar value or any other
 scalar-valued function---as the factors were only calculated for those two
 central tendencies. Also, it does not allow passing a user-defined constant, as
 the intent is to return the unbiased estimate assuming normality.

 If \code{na.rm} is \code{TRUE} then \code{NA} values are stripped from \code{x}
 before computation takes place. If this is not done then an \code{NA} value in
 \code{x} will cause \code{madn} to return \code{NA}.
}

\value{
A \strong{numeric} value representing the median absolute deviation from the
requested central tendency adjusted by the asymptotic normality constant and the
small-sample bias constant.
}

\references{
Croux, Christophe and Rousseeuw, Peter J. (1992) "Time-Efficient Algorithms for
Two Highly Robust Estimators of Scale", \emph{Computational Statistics}, Vol. 1,
411--428. \doi{10.1007/978-3-662-26811-7_58}

Adler, Avraham (2026) "Reducing the Bias in the Robust Estimation of Very Small
Samples with the revss package for R", Manuscript in preparation
}

\author{Avraham Adler \email{Avraham.Adler@gmail.com}}

\seealso{
See \code{\link{adm}}, \code{\link{admn}}, and \code{\link[stats]{mad}} for
other basic robust estimators of scale. See \code{\link{robScale}} for a robust
M-estimator of scale.
}

\examples{
set.seed(19L)
z <- rnorm(7, 8, 3)
sd(z); sd(z) / 3 - 1
mad(z); mad(z) / 3 - 1
madn(z); madn(z) / 3 - 1
madn(z, factors = "CR"); madn(z, factors = "CR") / 3 - 1
}

\keyword{univar}
\keyword{robust}
