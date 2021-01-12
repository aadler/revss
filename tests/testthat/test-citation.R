test_that("Version", {
  expect_match(toBibtex(citation('revss')),
               as.character(packageVersion('revss')), fixed = TRUE, all = FALSE)
})

