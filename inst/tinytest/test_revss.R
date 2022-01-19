## Generate Test Data
eff_seed <- sample(65536, 1)
set.seed(eff_seed)
x5 <- runif(5, 0, 100)
t5 <- median(x5)
adm5 <- mean(abs(x5 - t5))
mad5 <- median(abs(x5 - t5))
y <- c(9, 2, 14, 4)
naErr <- "There are NAs in the data yet na.rm is FALSE"

## ADM Tests
expect_equal(adm(x5), adm5 * sqrt(pi / 2))
expect_equal(adm(c(x5, NA), na.rm = TRUE), adm5 * sqrt(pi / 2))
expect_equal(adm(x5, constant = 1), adm5)
expect_equal(adm(c(x5, NA), constant = 1, na.rm = TRUE), adm5)
expect_true(is.na(adm(c(x5, NA))))
expect_true(is.na(adm(c(x5, NA), constant = 1)))

## RobLoc Tests
robLocTest <- function(x, na.rm = FALSE, tol = sqrt(.Machine$double.eps)) {
  if (na.rm) {
    x <- x[!is.na(x)]
  }
  if (length(x) <= 3) {
    return(median(x))
  } else {
    obj <- function(x, data) {
      sum((2 * plogis((data - x) / mad(data)) - 1)) ^ 2
    }
    fit <- optimize(f = obj, interval = range(x), data = x, tol = tol)
    return(fit$minimum)
  }
}

robLocScaleTest <- function(x, scale, na.rm = FALSE,
                            tol = sqrt(.Machine$double.eps)) {
  if (na.rm) {
    x <- x[!is.na(x)]
  }
  if (length(x) <= 2) {
    return(median(x))
  } else {
    obj <- function(x, data) {
      sum((2 * plogis((data - x) / scale) - 1)) ^ 2
    }
    fit <- optimize(f = obj, interval = range(x), data = x, tol = tol)
    return(fit$minimum)
  }
}

expect_equal(robLoc(x5), robLocTest(x5))
expect_equal(robLoc(x5, tol = .Machine$double.eps),
             robLocTest(x5, .Machine$double.eps))
expect_equal(robLoc(c(1, 9, 7)), median(c(1, 9, 7)))

# Known Location
expect_equal(robLoc(y, scale = 5), robLocScaleTest(y, scale = 5))
expect_equal(robLoc(c(1, 8, 12), scale = 5),
             robLocScaleTest(c(1, 8, 12), scale = 5))
expect_equal(robLoc(c(1, 8), scale = 5), median(c(1, 8)))
expect_false(isTRUE(all.equal(robLoc(c(1, 8, 12), scale = 5),
                              median(c(1, 8, 12)))))
# RobLoc Error Trapping
expect_error(robLoc(c(x5, NA)), pattern = naErr)
expect_equal(robLoc(c(x5, NA), na.rm = TRUE), robLoc(x5))

## RobScale Tests
expect_equal(robScale(y), 5.88048107946198)

# Test Exception Handling
expect_equal(robScale(y[1:3]), mad(y[1:3]))
expect_equal(robScale(c(0.00001, 0, 4)), adm(c(0.00001, 0, 4)))
expect_equal(robScale(c(0.0001, 0, 4)), mad(c(0.0001, 0, 4)))
# Excel precision probably lacking here.
expect_equal(robScale(c(0.0001, 0, 0, 4)), 0.000101541283431, tolerance = 1e-7)

robScaleLocTest <- function(x, loc) {
  x <- x - loc
  s <- 1.4826 * median(abs(x))
  converged <- FALSE
  k <- 0
  while (!converged & k < 80) {
    k <- k + 1
    v <- sqrt(2 * mean((2 * plogis(x / (s * 0.3739)) - 1) ^ 2))
    converged <- abs(v - 1) <= sqrt(.Machine$double.eps)
    s <- s * v
  }
  return(s)
}

# Test Known Location
expect_equal(robScale(y, loc = 7), robScaleLocTest(y, loc = 7))
expect_equal(robScale(1:3, loc = 3), robScaleLocTest(1:3, loc = 3))
expect_false(isTRUE(all.equal(robScale(1:3), robScaleLocTest(1:3, loc = 0))))
expect_equal(robScale(1:3), mad(1:3))

# Test Error Trapping
expect_error(robScale(c(x5, NA)), pattern = naErr)
expect_equal(robScale(c(x5, NA), na.rm = TRUE), robScale(x5))

# Test Citation
expect_true(any(grepl(packageVersion('revss'), toBibtex(citation('revss')),
                      fixed = TRUE)))

message(paste("Seed for test session:", eff_seed))
