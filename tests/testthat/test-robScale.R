eff_seed <- sample(65536, 1)
set.seed(eff_seed)
x5 <- runif(5, 0, 100)
t5 <- median(x5)
adm5 <- mean(abs(x5 - t5))
mad5 <- median(abs(x5 - t5))
y <- c(9, 2, 14, 4)

test_that("Accuracy", {
  expect_equal(robScale(y), 5.88048107946198)
})
test_that("Exception Handling", {
  expect_equal(robScale(y[1:3]), mad(y[1:3]))
  expect_equal(robScale(c(0.00001, 0, 4)), adm(c(0.00001, 0, 4)))
  expect_equal(robScale(c(0.0001, 0, 4)), mad(c(0.0001, 0, 4)))
  # Excel precision probably lacking here.
  expect_equal(robScale(c(0.0001, 0, 0, 4)), 0.000101541283431,
               tolerance = 1e-7)
})

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

test_that("Known Location", {
  expect_equal(robScale(y, loc = 7), robScaleLocTest(y, loc = 7))
  expect_equal(robScale(1:3, loc = 3), robScaleLocTest(1:3, loc = 3))
  expect_false(isTRUE(all.equal(robScale(1:3), robScaleLocTest(1:3, loc = 0))))
  expect_equal(robScale(1:3), mad(1:3))
})

test_that("Error Trapping", {
  expect_error(robScale(c(x5, NA)),
               regexp = "There are NAs in the data yet na.rm is FALSE")
  expect_equal(robScale(c(x5, NA), na.rm = TRUE), robScale(x5))
})
print(paste("Seed for robScale test session:", eff_seed))
