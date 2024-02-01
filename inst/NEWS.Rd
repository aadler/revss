% Copyright (c) 2020, Avraham Adler All rights reserved
% SPDX-License-Identifier: BSD-2-Clause

\name{NEWS}
\alias{NEWS}
\title{NEWS file for the revss package}

\section{Version 1.0.6 (2023-08-07)}{
  \subsection{Changed}{
    \itemize{
      \item Add \acronym{SPDX} codes to source files.
      \item Update \file{README} and Github actions.
    }
  }
}

\section{Version 1.0.5 (2023-02-01)}{
  \subsection{Added}{
    \itemize{
      \item Explictly mention use case for package to be 3--8 samples.
      \item Note that asymptotic constant for \code{adm} may not apply with few
      samples.
    }
  }
  \subsection{Changed}{
    \itemize{
      \item Update README.
      \item Update Github actions.
      \item Make code more compliant with style guide.
      \item CITATION updated to use \code{bibentry} per \acronym{CRAN} request.
    }
  }
}

\section{Version 1.0.4 (2022-04-03)}{
  \subsection{Changed}{
    \itemize{
      \item Explictly use integers in count and lengths.
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
      \item Converted test suite to \code{tinytest} to reduce dependencies.
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
      \item Cleaned up help files and README.
      \item Cleaned up source code and added \acronym{SPDX} identifiers.
      \item Moved continuous integration to Github Actions.
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
      \item Considered mature enough for official \dQuote{release}.
      \item Changed tests to be \code{testthat} 3rd edition compliant.
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
      \item Updated README.
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
