% Copyright (c) 2020, Avraham Adler All rights reserved
% SPDX-License-Identifier: BSD-2-Clause

\name{robScale}
\alias{robScale}
\title{Robust Estimate of Scale}
\description{Compute the robust estimate of scale for very small samples.}
\usage{
robScale(x, loc = NULL, implbound = 1e-4, na.rm = FALSE, maxit = 80L,
         tol = NULL, factors = c("AA", "CR"))
}
\arguments{
  \item{x}{\strong{numeric}; A vector of values.}
  \item{loc}{\strong{numeric}; The location, if known, can be used to enhance
  the estimate for the scale. Defaults to unknown.}
  \item{implbound}{\strong{numeric}; The smallest value that \code{mad} is
  allowed before being considered too close to 0.}
  \item{na.rm}{\strong{logical}; If \code{TRUE} then \code{NA} values are
  stripped from \code{x} before computation takes place.}
  \item{maxit}{\strong{numeric}; The maximum number of iterations. Defaults to
  80.}
  \item{tol}{\strong{numeric}; The desired numeric tolerance. Defaults to the
  square root of \code{.Machine$double.eps} or roughly
  \eqn{1.49\times 10^{-8}}{1.49e-8}.}
  \item{factors}{\strong{character}; \code{"CR"} will use the factors calculated
  in Croux & Rousseeuw (1992) while \code{"AA"} (default) will use the factors
  calculated by the package author.}
}
\details{
Computes the M-estimator for scale using a smooth \eqn{\rho}-function defined as
the square of the logistic \eqn{\psi} function used in location estimation
(Rousseeuw & Verboven, 2002, 4.2). When the sequence of observations is too
short for a robust estimate, the scale estimate will default to \code{mad} so
long as \code{mad} has not \dQuote{imploded}, i.e. it is greater than
\code{implbound} which defaults to 0.0001. When \code{mad} has imploded,
\code{adm} is used instead.

If the location is known and passed through \code{loc}, the algorithm uses the
suggestion in Rousseeuw & Verboven section 5 (2002) converting the observations
to distances from 0 and iterating on the adjusted sequence.

If \code{na.rm} is \code{TRUE} then \code{NA} values are stripped from \code{x}
before computation takes place. If this is not done then an \code{NA} value in
\code{x} will return an error.

The tolerance and number of iterations are similar to those in existing base \R
functions.

Rousseeuw & Verboven suggest using this function when there are 3--8 samples.
It is implied that having more than 8 samples allows the use of more standard
estimators.
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
Croux, Christophe and Rousseeuw, Peter J. (1992)
\href{https://wis.kuleuven.be/stat/robust/papers/publications-1992/crouxrousseeuw-timeeffalgosnqn-compstat-1992.pdf}{
"Time-Efficient Algorithms for Two Highly Robust Estimators of Scale"},
\emph{Computational Statistics}, Vol. 1, 411--428

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
robScale(c(1:9))
x <- c(1,2,3,5,7,8)
c(robScale(x), robScale(x, loc = 5))
}

\keyword{univar}
\keyword{robust}
