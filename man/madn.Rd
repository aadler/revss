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
  Monte-Carlo simulation for either the median absolute distance from the median
  or from the mean.
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
  factors calculated by the package author. Note that if
  \code{center == "mean"}, there are no \code{CR} factors and the \code{AA}
  factors will be used.}
  \item{na.rm}{\strong{logical}; If \code{TRUE} then \code{NA} values are
  stripped from \code{x} before computation takes place.}
}
\details{
 \deqn{MAD_n = b_n\;1.4826\;\underset{i}{\textrm{med}}\;|x_i -
 \underset{j}{\textrm{med}}\;x_j|}{MADn = b_n * 1.4826 * median(abs(x -
 median(x)))}

 where \eqn{b_n} is calculated either by Croux & Rousseeuw (1992) or by
 Adler (unpublished).

 Croux & Rousseeuw (1992) used Monte-Carlo methods to calculate correction
 factors to make the standard \acronym{MAD} estimate more unbiased for small
 samples. They called this new function \eqn{\textrm{MAD}_n} to differentiate it
 from \eqn{\textrm{MAD}}, given the \eqn{b_n} multiplier is dependent on
 \eqn{n}---the size of the sample. This function can apply those factors to the
 \code{\link[stats]{mad}} function already existing in \pkg{stats}.

 Inspired by Croux & Rousseeuw, the package author ran a significantly larger
 Monte-Carlo simulation for both the median absolute deviation from the median
 and the median absolute deviation from the mean. This function can use those
 factors as well.

 However, unlike \code{mad}, this function only accepts \code{"median"} or
 \code{"mean"} as its central tendency, and not a scalar value or any other
 scalar-valued function, as the factors were only calculated for those two
 functions.

 Second, it does not allow passing a user-defined constant, as the intent is to
return the unbiased estimate assuming normality.
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
}

\author{Avraham Adler \email{Avraham.Adler@gmail.com}}

\seealso{
See \code{\link{adm}} in this package for the average/mean deviation from the
\code{\link{median}}, \code{\link[stats]{mad}} from \pkg{stats} for the
\dQuote{standard} median absolute deviation from the median, and
\code{\link[robustbase]{Sn}} and \code{\link[robustbase]{Qn}} from
\pkg{robustbase} for other robust measures of scale by Croux & Rousseeuw.
}

\examples{
x <- 1:5
madn(x)
madn(x, center = "mean")

# The length 5 CR correction constant is 1.206
all.equal(madn(x, factors = "CR"), 1.206 * mad(x))

# The length 5 AA constant for deviation from median is 1.2158502434732232
all.equal(madn(x), 1.2158502434732232 * mad(x))

# The length 5 AA constant for deviation from mean is 1.074608827423805
all.equal(madn(x, center = "mean"),
          mad(x, center = mean(x)) * 1.074608827423805)
}

\keyword{univar}
\keyword{robust}
