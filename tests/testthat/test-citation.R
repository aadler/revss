test_that("Version", {
  expect_match(toBibtex(citation('revss')),
               as.character(packageVersion('revss')), fixed = TRUE, all = FALSE)
  # expect_match(scan("../../README.md", what = 'character'),
  #              as.character(packageVersion('revss')), fixed = TRUE, all = FALSE)
})

