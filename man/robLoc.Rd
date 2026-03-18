% Copyright (c) 2020, Avraham Adler All rights reserved
% SPDX-License-Identifier: BSD-2-Clause

\name{robLoc}
\alias{robLoc}
\title{Robust Estimate of Location}
\description{Compute a robust estimate of location for very small samples.}
\usage{
robLoc(x, scale = NULL, factors = c("AA", "CR"), na.rm = FALSE, opts = list())
}
\arguments{
  \item{x}{\strong{numeric}; A vector of values.}
  \item{scale}{\strong{numeric}; The scale, if known, can be used to enhance the
  estimate for the location. Defaults to unknown.}
  \item{factors}{\strong{character}; \code{"CR"} will use the small-sample bias
  factors for \code{madn} calculated in Croux & Rousseeuw (1992) while
  \code{"AA"} (default) will use the factors calculated by the package author
  (2026).}
  \item{na.rm}{\strong{logical}; If \code{TRUE} then \code{NA} values are
  stripped from \code{x} before computation takes place.}
  \item{opts}{\link{list}; Configuration options including:
    \itemize{
      \item \code{maxit}: \strong{integer}; The maximum number of iterations.
      Defaults to 80.
      \item \code{tol}: \strong{numeric}; The desired numeric tolerance for
      algorithmic convergence. Defaults to the square root of
      \code{.Machine$double.eps} or roughly \eqn{1.49\times 10^{-8}}{1.49e-8}.
    }
  }
}
\details{
Computes the M-estimator for location using the logistic \eqn{\psi} function of
Rousseeuw & Verboven (2002, 4.1). If there are three or fewer entries, the
function defaults to the \code{median}.

If the scale is known and passed through \code{scale}, the algorithm uses the
suggestion in Rousseeuw & Verboven section 5 (2002), substituting the known
scale for the \code{madn}.

If \code{na.rm} is \code{TRUE} then \code{NA} values are stripped from \code{x}
before computation takes place. If this is not done then an \code{NA} value in
\code{x} will return an error.

The tolerance and number of iterations are similar to those in existing base \R
functions.
}
\value{
Solves for the robust estimate of location, \eqn{T_n}{Tn}, which is the solution
to
\deqn{\frac{1}{n}\sum_{i = 1}^n\psi\left(\frac{x_i - T_n}{S_n}\right) = 0}{
mean(\psi((xi - Tn)/Sn)) = 0}

where \eqn{S_n}{Sn} is fixed at \code{madn(x)}. Which \eqn{b_n}{bn} factors are
passed to \code{madn} for calculating \eqn{S_n}{Sn} is determined by the value
of \code{factors}.

The \eqn{\psi}-function selected by Rousseeuw & Verboven is:

\deqn{\psi_{log}(x) = \frac{e^x - 1}{e^x + 1}}{\psi(x) = (exp(x) - 1) /
(exp(x) + 1)}

This is equivalent to \code{2 * plogis(x) - 1}.
}
\references{
Croux, Christophe and Rousseeuw, Peter J. (1992) "Time-Efficient Algorithms for
Two Highly Robust Estimators of Scale", \emph{Computational Statistics}, Vol. 1,
411--428. \doi{10.1007/978-3-662-26811-7_58}

Rousseeuw, Peter J. and Verboven, Sabine (2002) Robust estimation in very small
samples. \emph{Computational Statistics & Data Analysis}, \bold{40}, (4),
741--758. \doi{10.1016/S0167-9473(02)00078-6}

Adler, Avraham (2026) "Reducing the Bias in the Robust Estimation of Very Small
Samples with the revss package for R", Manuscript in preparation
}

\author{Avraham Adler \email{Avraham.Adler@gmail.com}}
\seealso{
\code{\link{median}}
}
\examples{
set.seed(19L)
z <- rnorm(7, 8, 3)
mean(z); mean(z) / 8 - 1
median(z); median(z) / 8 - 1
robLoc(z); robLoc(z) / 8 - 1
robLoc(z, factors = "CR"); robLoc(z, factors = "CR") / 8 - 1
}

\keyword{univar}
\keyword{robust}
