% Copyright (c) 2020, Avraham Adler All rights reserved
% SPDX-License-Identifier: BSD-2-Clause

\name{NEWS}
\alias{NEWS}
\title{NEWS file for the revss package}
\encoding{UTF-8}

\section{Version 3.1.0 (2026-03-18)}{
  \itemize{
    \item Version 3.0.0 was released prematurely. Version 3.1.0 is effectively
    the second half of version 3.0.0.
  }
  \subsection{Changed}{
    \itemize{
      \item \strong{Breaking}: \code{robScale} uses the bias-corrections factors
      by default. Testing shows that the improvement is measurable and
      significant.
      \item \strong{Breaking}: \code{robLoc} and \code{robScale} refactored to
      move lesser-used options into an \code{opts} list and have a consistent
      parameter order across the package.
      \item Function examples now better demonstrate their usefulness.
      \item Refactored and updated unit tests.
    }
  }
  \subsection{Fixed}{
    \itemize{
      \item Corrected and updated documentation.
    }
  }
  \subsection{Removed}{
    \itemize{
      \item Removed unused, unexposed functions \code{medianR} and \code{madf}
      carried over from older development.
    }
  }
}

\section{Version 3.0.0 (2026-03-18)}{
  \subsection{Added}{
    \itemize{
      \item New exported functions \code{madn} and \code{admn} providing
      high-precision small-sample bias-corrected versions of the \acronym{MAD}
      and \acronym{ADM}.
      \item New optional constants for bias reduction in \code{robScale} (via
      \code{usefctrs} and \code{madfctrs}).
    }
  }
  \subsection{Changed}{
    \itemize{
      \item \strong{Major rewrite}: Complete port of the computational core to
      modern Fortran 90, including a new optimized quicksort-based median
      algorithm for small \eqn{n}. This gives substantially better performance,
      cleaner code, and improved \code{NA} handling in line with base \R.
      \item \strong{Breaking}: All small-sample (\eqn{n \le 9}) and asymptotic
      bias-correction factors for \code{madn}, \code{admn}, and \code{robScale}
      (both known and unknown location cases) were recomputed using 200 million
      Monte Carlo simulations (small \eqn{n}) and 16.5 million simulations per
      sample size (asymptotic: \eqn{10 \le n \le 100}). The new 4-decimal
      \dQuote{AA} constants have Monte Carlo standard errors between
      \eqn{2.0 \times 10^{-5}}{2e-5} and \eqn{9.1 \times 10^{-5}}{9.1e-5}. The
      original Croux & Rousseeuw (\dQuote{CR}) factors remain available as an
      option in \code{madn} and \code{robScale}
      (\href{https://github.com/aadler/revss/issues/1}{Issue #1}; thank you
      \href{https://github.com/filiporn}{@filiporn}).
      \item \strong{Breaking}: \code{robLoc} and \code{robScale} now use the new
      \code{madn}/\code{admn} internally with improved very-small-sample logic.
      The new \dQuote{AA} factors are now the default.
      \item Unit tests expanded and modernized.
      \item Documentation, GitHub workflows, and package metadata updated.
    }
  }
  \subsection{Fixed}{
    \itemize{
      \item Various spelling, punctuation, and metadata issues.
      \item Corrected package metadata unit test.
    }
  }
}

\section{Version 2.0.0 (2024-06-20)}{
  \subsection{Changed}{
    \itemize{
      \item \strong{Breaking:} In \code{robScale}, the constant representing
      the denominator for \eqn{x} (see equation 26)---which allows for
      \eqn{\beta = \int{\rho(u)\;d\Phi(u)} = 0.5}{beta =
      integral of rho(u) d Phi(u) = 0.5}---was calculated to greater precision
      than the four digits shown in the paper. This changes results slightly,
      which is why the major version has been incremented.
      \item Updated documentation.
      \item Updated unit tests.
      \item Expanded package metadata tests.
      \item Use native \acronym{CRAN} \acronym{DOI}.
    }
  }
  \subsection{Added}{
    \itemize{
      \item Added \pkg{rhub} checking.
    }
  }
}

\section{Version 1.0.6 (2024-02-01)}{
  \subsection{Changed}{
    \itemize{
      \item Add \acronym{SPDX} codes to source files.
      \item Update \file{README}, GitHub actions, and unit tests.
    }
  }
}

\section{Version 1.0.5 (2023-02-01)}{
  \subsection{Added}{
    \itemize{
      \item Explicitly mention use case for package to be 3--8 samples.
      \item Note that asymptotic constant for \code{adm} may not apply with few
      samples.
    }
  }
  \subsection{Changed}{
    \itemize{
      \item Update \file{README}.
      \item Update GitHub actions.
      \item Make code more compliant with style guide.
      \item \file{CITATION} updated to use \code{bibentry} per \acronym{CRAN}
      request.
    }
  }
}

\section{Version 1.0.4 (2022-04-03)}{
  \subsection{Changed}{
    \itemize{
      \item Explicitly use integers in count and lengths.
      \item Use singleton logical comparisons for short-circuit.
      \item Update \file{README} for Best Practice.
    }
  }
  \subsection{Added}{
    \itemize{
      \item Added Best Practice badge to \file{README}.
    }
  }
}

\section{Version 1.0.3 (2022-01-19)}{
  \subsection{Changed}{
    \itemize{
      \item Converted test suite to \pkg{tinytest} to reduce dependencies.
      \item Augmented citation with \acronym{DOI}.
    }
  }
}

\section{Version 1.0.2 (2021-01-12)}{
  \subsection{Fixed}{
    \itemize{
      \item Corrected \code{adm} documentation.
    }
  }
  \subsection{Changed}{
    \itemize{
      \item Cleaned up help files and \file{README}.
      \item Cleaned up source code and added \acronym{SPDX} identifiers.
      \item Moved continuous integration to GitHub Actions.
    }
  }
}

\section{Version 1.0.1 (2020-11-10)}{
  \subsection{Fixed}{
    \itemize{
      \item Corrected \acronym{CRAN} requests.
    }
  }
}

\section{Version 1.0.0 (2020-11-08)}{
  \subsection{Changed}{
    \itemize{
      \item Considered mature enough for official release.
      \item Changed tests to be \pkg{testthat} 3rd edition compliant.
      \item Changed default \code{maxit} to 80.
    }
  }
  \subsection{Added}{
    \itemize{
      \item Added AppVeyor.
      \item Added more tests.
    }
  }
  \subsection{Fixed}{
    \itemize{
      \item Updated \file{README}.
    }
  }
}

\section{Version 0.0.2 (2020-05-28)}{
  \subsection{Fixed}{
    \itemize{
      \item Minor corrections in DESCRIPTION for \acronym{CRAN}.
    }
  }
}

\section{Version 0.0.1 (2020-05-27)}{
  \subsection{Added}{
    \itemize{
      \item Initial version.
    }
  }
}
