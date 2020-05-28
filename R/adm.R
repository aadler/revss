# Average Deviation from the Median with bias correction.
# Patterned after 'mad' in stats
adm <- function(x, center = median(x), constant = sqrt(pi / 2), na.rm = FALSE) {
  if (na.rm) {
    x <- x[!is.na(x)]
  }
  constant * mean(abs(x - center))
}

# Note, simulation studies show that while adm normality constarnt symptotically
# approaches sqrt(pi / 2), for small samples it is more akin to
# 1.296816 * exp(n * -exp(7.647996)) + 0.2757346 * exp(n * -exp(-1.664514))
# where n is the number of observations.
