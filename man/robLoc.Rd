% Copyright (c) 2020, Avraham Adler All rights reserved
% SPDX-License-Identifier: BSD-2-Clause

\name{robLoc}
\alias{robLoc}
\title{Robust Estimate of Location}

\description{Compute the robust estimate of location for very small samples.}
\usage{
robLoc(x, scale = NULL, na.rm = FALSE, maxit = 80L, tol = sqrt(.Machine$double.eps))
}
\arguments{
  \item{x}{A numeric vector.}
  \item{scale}{The scale, if known, can be used to enhance the estimate for the
  location; defaults to unknown.}
  \item{na.rm}{If \code{TRUE} then \code{NA} values are stripped from \code{x}
  before computation takes place.}
  \item{maxit}{The maximum number of iterations; defaults to 80.}
  \item{tol}{The desired accuracy.}
}
\details{
Computes the M-estimator for location using the logistic \eqn{\psi} function of
Rousseeuw & Verboven (2002, 4.1). If there are three or fewer entries, the
function defaults to the \code{median}.

If the scale is known and passed through \code{scale}, the algorithm uses the
suggestion in Rousseeuw & Verboven section 5 (2002), substituting the known
scale for the \code{mad}.

If \code{na.rm} is \code{TRUE} then \code{NA} values are stripped from \code{x}
before computation takes place.  If this is not done then an \code{NA} value in
\code{x} will cause \code{mad} to return \code{NA}.

The tolerance and number of iterations are similar to those in existing base R
functions.

Rousseeuw & Verboven suggest using this function when there are 3--8 samples.
It is implied that having more than 8 samples allows the use of more standard
estimators.
}
\value{
Solves for the robust estimate of location, \eqn{T_n}{Tn}, which is the solution
to
\deqn{\frac{1}{n}\sum_{i = 1}^n\psi\left(\frac{x_i - T_n}{S_n}\right) = 0}{
mean(\psi((xi - Tn)/Sn)) = 0}

where \eqn{S_n}{Sn} is fixed at \code{mad(x)}. The \eqn{\psi}-function selected
by Rousseeuw & Verboven is:

\deqn{\psi_{log}(x) = \frac{e^x - 1}{e^x + 1}}{\psi(x) = (exp(x) - 1) /
(exp(x) + 1)}

This is equivalent to \code{2 * plogis(x) - 1}.
}
\references{
Rousseeuw, Peter J. and Verboven, Sabine (2002) Robust estimation in very small
samples. \emph{Computational Statistics & Data Analysis}, \bold{40}, (4),
741--758. \doi{10.1016/S0167-9473(02)00078-6}
}
\author{Avraham Adler \email{Avraham.Adler@gmail.com}}
\seealso{
\code{\link{median}}
}
\examples{
robLoc(c(1:9))
x <- c(1,2,3,5,7,8)
robLoc(x)
}

\keyword{univar}
\keyword{robust}
