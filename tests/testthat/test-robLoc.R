eff_seed <- sample(65536, 1)
set.seed(eff_seed)
x5 <- runif(5, 0, 100)
t5 <- median(x5)
adm5 <- mean(abs(x5 - t5))
mad5 <- median(abs(x5 - t5))
y <- c(9, 2, 14, 4)

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

test_that("Accuracy", {
  expect_equal(robLoc(x5), robLocTest(x5))
  expect_equal(robLoc(x5, tol = .Machine$double.eps),
               robLocTest(x5, .Machine$double.eps))
  expect_equal(robLoc(c(1, 9, 7)), median(c(1, 9, 7)))
})

test_that("Known Location", {
  expect_equal(robLoc(y, scale = 5), robLocScaleTest(y, scale = 5))
  expect_equal(robLoc(c(1, 8, 12), scale = 5),
               robLocScaleTest(c(1, 8, 12), scale = 5))
  expect_equal(robLoc(c(1, 8), scale = 5), median(c(1, 8)))
  expect_false(isTRUE(all.equal(robLoc(c(1, 8, 12), scale = 5),
                                median(c(1, 8, 12)))))
})

test_that("Error Trapping", {
  expect_error(robLoc(c(x5, NA)),
               regexp = "There are NAs in the data yet na.rm is FALSE")
  expect_equal(robLoc(c(x5, NA), na.rm = TRUE), robLoc(x5))
})
print(paste("Seed for robLoc test session:", eff_seed))
