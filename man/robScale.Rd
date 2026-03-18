% Copyright (c) 2020, Avraham Adler All rights reserved
% SPDX-License-Identifier: BSD-2-Clause

\name{robScale}
\alias{robScale}
\title{Robust Estimate of Scale}
\description{Compute the robust estimate of scale for very small samples.}
\usage{
robScale(x, loc = NULL, na.rm = FALSE, opts = list())
}
\arguments{
  \item{x}{\strong{numeric}; A vector of values.}
  \item{loc}{\strong{numeric}; The location---if known---can be used to enhance
  the estimate for the scale. Defaults to unknown.}
  \item{na.rm}{\strong{logical}; If \code{TRUE} then \code{NA} values are
  stripped from \code{x} before computation takes place.}
  \item{opts}{\link{list}; Configuration options including:
    \itemize{
      \item \code{maxit}: \strong{integer}; The maximum number of iterations.
      Defaults to 80.
      \item \code{tol}: \strong{numeric}; The desired numeric tolerance for
      algorithmic convergence. Defaults to the square root of
      \code{.Machine$double.eps} or roughly \eqn{1.49\times 10^{-8}}{1.49e-8}.
      \item \code{usefctrs}: \strong{logical}; If \code{TRUE} (default), then
      the small-sample bias factors for \code{robScale} will be used. If
      \code{FALSE}, no factors will be applied.
      \item \code{madfctrs}: \strong{character}; when passing data to
      \code{madn} because of too few observations, \code{"CR"} will use the
      factors calculated in Croux & Rousseeuw (1992) while \code{"AA"} (default)
      will use the factors calculated by the package author.
      \item \code{implbound}: \strong{numeric}; when passing data to
      \code{madn} because of too few observations, this is the smallest value
      \code{madn} is allowed before switching to \code{admn} due to implosion.
      Defaults to \eqn{1\times 10^{-4}}{1e-4}.
    }
  }
}
\details{
Computes the M-estimator for scale using a smooth \eqn{\rho}-function defined as
the square of the logistic \eqn{\psi} function used in location estimation
(Rousseeuw & Verboven, 2002, 4.2). When the sequence of observations is too
short for a robust estimate, the scale estimate will default to \code{madn} so
long as \code{madn} has not \dQuote{imploded}, i.e. it is greater than
\code{implbound} which defaults to \eqn{1\times 10^{-4}}{1e-4}. When \code{madn}
has imploded, \code{admn} is used instead.

If the location is known and passed through \code{loc}, the algorithm uses the
suggestion in Rousseeuw & Verboven section 5 (2002) converting the observations
to distances from 0 and iterating on the adjusted sequence.

If \code{na.rm} is \code{TRUE} then \code{NA} values are stripped from \code{x}
before computation takes place. If this is not done then an \code{NA} value in
\code{x} will return an error.

The tolerance and number of iterations are similar to those in existing base \R
functions.
}
\value{
Solves for the robust estimate of scale, \eqn{S_n}{Sn}, which is the solution
to\deqn{\frac{1}{n}\sum_{i = 1}^n\rho\left(\frac{x_i - T_n}{S_n}\right) = \beta
}{mean(\rho((xi - Tn)/Sn)) = \beta}
where \eqn{T_n}{Tn} is fixed at \code{median(x)} and \eqn{\beta} is fixed at
0.5. The \eqn{\rho}-function selected by Rousseeuw & Verboven is based on the
square of the \eqn{\psi}-function used in \code{\link{robLoc}}. Specifically
\deqn{\rho_{log}(x) = \psi_{log}^2\left(\frac{x}{0.37394112142347236}\right)
}{\rho(x) = \psi^2(x / 0.37394112142347236)}
The constant 0.37394112142347236 is necessary so that
\deqn{\beta = \int\rho(u)\;d\Phi(u)=0.5}{\beta = Int\rho(u)d\Phi(u)=0.5}
}
\references{
Croux, Christophe and Rousseeuw, Peter J. (1992) "Time-Efficient Algorithms for
Two Highly Robust Estimators of Scale", \emph{Computational Statistics}, Vol. 1,
411--428. \doi{10.1007/978-3-662-26811-7_58}

Rousseeuw, Peter J. and Verboven, Sabine (2002) Robust estimation in very small
samples. \emph{Computational Statistics & Data Analysis}, \bold{40}, (4),
741--758. \doi{10.1016/S0167-9473(02)00078-6}
}
\author{Avraham Adler \email{Avraham.Adler@gmail.com}}
\seealso{
See \code{\link{adm}}, \code{\link[stats]{mad}}, and \code{\link{madn}} for more
basic robust estimators of scale.

See \code{\link[robustbase]{Qn}} and \code{\link[robustbase]{Sn}} in the
\href{https://CRAN.R-project.org/package=robustbase}{\pkg{robustbase}} package
for more specialized robust scale estimators for larger samples. These last two
are based on code written by Peter Rousseeuw.
}
\examples{
set.seed(19L)
z <- rnorm(7, 8, 3)
sd(z); sd(z) / 3 - 1
admn(z); admn(z) / 3 - 1
madn(z); madn(z) / 3 - 1
robScale(z); robScale(z) / 3 - 1
robScale(z, opts = list(usefctrs = FALSE))
robScale(z, opts = list(usefctrs = FALSE)) / 3 - 1
}

\keyword{univar}
\keyword{robust}
