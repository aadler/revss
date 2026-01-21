% Copyright (c) 2026, Avraham Adler All rights reserved
% SPDX-License-Identifier: BSD-2-Clause

\name{admn}
\alias{admn}
\title{Mean Absolute Deviation from the Median or Mean for Small Samples}
\description{Compute the mean absolute deviation from the median, also known as
the average deviation to the median (\acronym{ADM}) and adjust by applying
factors calculated specifically for small-sample size to achieve unbiased
asymptotic normal consistency.}
\usage{
admn(x, center = c("median", "mean"), na.rm = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{\strong{numeric}; A vector of values.}
  \item{center}{\strong{character}; either \code{"median"} or \code{"mean"}
  which will be used as the function to calculate the central tendency from
  which to measure the absolute deviations. Defaults to \code{"median"}.}
  \item{na.rm}{\strong{logical}; If \code{TRUE} then \code{NA} values are
  stripped from \code{x} before computation takes place.}
}
\details{
\deqn{ADM = a_n\sqrt{\frac{\pi}{2}}\frac{1}{n}\sum_{i=1}^n{|x_i -
\textrm{center}(x)|}}{ADM = a_n * sqrt(pi / 2) * mean(abs(x - center(x)))}

Similar to Croux & Rousseeuw (1992), a large-scale Monte-Carlo simulation was
performed to calculate correction factors to make the standard \acronym{ADM}
estimate more unbiased for small samples. It is called \eqn{\textrm{ADM}_n},
to differentiate it from the more standard \eqn{\textrm{ADM}}, given the
\eqn{a_n} multiplier is dependent on \eqn{n}---the size of the sample.

This function differs from its larger-scale version, \code{\link{adm}}, in other
ways. First, it only accepts \code{"median"} or \code{"mean"} as its central
tendency, and not a scalar value or any other scalar-valued function, as the
factors were only calculated for those two functions.

Second, it does not allow passing a user-defined constant, as the intent is to
return the unbiased estimate assuming normality.
}
\value{
A \strong{numeric} value representing the average absolute deviation from the
requested central tendency adjusted by the asymptotic normality constant and the
small-sample bias-reduction constant.
}
\references{
Croux, Christophe and Rousseeuw, Peter J. (1992) "Time-Efficient Algorithms for
Two Highly Robust Estimators of Scale", \emph{Computational Statistics}, Vol. 1,
411--428. \doi{10.1007/978-3-662-26811-7_58}
}
\author{Avraham Adler \email{Avraham.Adler@gmail.com}}
\seealso{
See \code{\link{adm}} for the large-sample version of this function,
\code{\link[stats]{mad}} in \pkg{stats} for the median absolute deviation
from the \code{\link{median}}, and \code{\link{madn}} in this package for the
small-sample bias-corrected version of \code{mad}.
}
\examples{
admn(c(1:9))
admn(c(1:9), center = "mean")
}

\keyword{univar}
\keyword{robust}
