eff_seed <- sample(65536, 1)
set.seed(eff_seed)
x5 <- runif(5, 0, 100)
t5 <- median(x5)
adm5 <- mean(abs(x5 - t5))
mad5 <- median(abs(x5 - t5))
y <- c(9, 2, 14, 4)

test_that("Accuracy", {
  expect_equal(adm(x5), adm5 * sqrt(pi / 2))
  expect_equal(adm(c(x5, NA), na.rm = TRUE), adm5 * sqrt(pi / 2))
  expect_equal(adm(x5, constant = 1), adm5)
  expect_equal(adm(c(x5, NA), constant = 1, na.rm = TRUE), adm5)
})

test_that("Error Trapping", {
  expect_true(is.na(adm(c(x5, NA))))
  expect_true(is.na(adm(c(x5, NA), constant = 1)))
})
print(paste("Seed for ADM test session:", eff_seed))
