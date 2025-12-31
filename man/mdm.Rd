% Copyright (c) 2025, Avraham Adler All rights reserved
% SPDX-License-Identifier: BSD-2-Clause

\name{mdm}
\alias{mdm}
\title{
Median Deviation from the Median (Median Absolute Deviation) for Small Samples
}
\description{
  The median absolute deviation \acronym{MAD} is actually the median distance
  to the median. For small samples, the normal bias correction of 1.4826 has
  been shown by Croux & Rousseeuw (1992) to be insufficient. This function
  applies the correction factors found in that paper. To prevent confusion, it
  uses the name suggested in Rousseeuw & Verboven (2002).
}
\usage{
mdm(x, na.rm = FALSE)
}
\arguments{
  \item{x}{\strong{numeric}; A vector of values.}
  \item{na.rm}{\strong{logical}; If \code{TRUE} then \code{NA} values are
  stripped from \code{x} before computation takes place.}
}
\details{
 Croux & Rousseeuw (1992) used Monte-Carlo methods to calculate correction
 factors to make the standard MAD estimate more unbiased for small samples.
 This function simply applies those factors to the \code{\link[stats]{mad}}
 function already existing in \pkg{stats}.
}
\value{
\deqn{MDM_n = b_n\;1.4826\;\underset{i}{\textrm{med}}\;|x_i -
\underset{j}{\textrm{med}}\;x_j|}{MDM = b_n * 1.4826 *
median(abs(x - median(x)))}

where \eqn{b_n} is calculated by Croux & Rousseeuw (1992).
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
See \code{\link{adm}} in this package for the average deviation from the
\code{\link{median}}, \code{\link[stats]{mad}} from \pkg{stats} for the
\dQuote{standard} median absolute deviation from the median, and
\code{\link[robustbase]{Sn}} and \code{\link[robustbase]{Qn}} from
\pkg{robustbase} for other robust measures of scale by Croux & Rousseeuw.
}
\examples{
X <- c(1, 2, 3, 4, 5)
mdm(X)

# The correction constant for length 5 is 1.206
all.equal(mdm(X), 1.206 * mad(X))
}

\keyword{univar}
\keyword{robust}
