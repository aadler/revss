\name{adm}
\alias{adm}
\title{Average Distance to the Median}

\description{Compute the mean absolute deviation from the median, and (by
default) adjust by a factor for asymptotically normal consistency.}

\usage{adm(x, center = median(x), constant = sqrt(pi / 2), na.rm = FALSE)}

\arguments{
  \item{x}{A numeric vector.}
  \item{center}{The central value from which to measure the average distance.
  Defaults to the median.}
  \item{constant}{A scale factor for asymptotic normality.  In large samples,
  the \code{adm} asymptotically approaches
  \eqn{\sqrt{\frac{2}{\pi}}}{\code{sqrt(2 / pi)}} times the sample standard
  deviation.}
  \item{na.rm}{If \code{TRUE} then \code{NA} values are stripped from \code{x}
  before computation takes place.}
}

\details{
Computes the average distance, as an absolute value, between each
observation and the central observation---usually the median.  In statistical
literature this is also called the \bold{mean absolute deviation around the
median}.  Unfortunately, this shares the same acronym as the median absolute
deviation (\acronym{MAD}), which is the median equivalent of this function.

The default is to adjust the factor for asymptotically normal consistency.  In
large samples this approaches \eqn{\sqrt{\frac{2}{\pi}}}{\code{sqrt(2 / pi)}},
which is the default.  In smaller samples, simulation studies suggest for
samples of up to approximately length \eqn{n = 50}, it behaves more akin to
\eqn{1.296816 e^{n \times -e^{7.647996}} + 0.2757346 e^{n \times -e^{-1.664514}}
}{1.296816 * exp(n * -exp(7.647996)) + 0.2757346 * exp(n * -exp(-1.664514))}.

If \code{na.rm} is \code{TRUE} then \code{NA} values are stripped from \code{x}
before computation takes place.  If this is not done then an \code{NA} value in
\code{x} will cause \code{mad} to return \code{NA}.
}
\value{\deqn{ADM = C\frac{1}{n}\sum_{i=1}^n{|x_i - median(x)}}{ADM = C *
mean(sum(abs(x - median(x))))}
where \eqn{C} is the consistency constant.}
\references{
Nair, K. R. (1947) A Note on the Mean Deviation from the Median.
\emph{Biometrika}, \bold{34}, 3/4, 360--362. \doi{10.2307/2332448}
}

\author{Avraham Adler \email{Avraham.Adler@gmail.com}}

\seealso{
\code{\link{mad}} for the median absolute deviation from the
\code{\link{median}}
}

\examples{
adm(c(1:9))
x <- c(1,2,3,5,7,8)
c(adm(x), adm(x, constant = 1))
}

\keyword{univar}
\keyword{robust}
