test_that("TRUE and FALSE parsed", {
  expect_equal(parse_logical(c("TRUE", "FALSE")), c(TRUE, FALSE))
})

test_that("true and false parsed", {
  expect_equal(parse_logical(c("true", "false")), c(TRUE, FALSE))
})

test_that("True and False parsed", {
  expect_equal(parse_logical(c("True", "False")), c(TRUE, FALSE))
})

test_that("T and F parsed", {
  expect_equal(parse_logical(c("T", "F")), c(TRUE, FALSE))
})

test_that("t and f parsed", {
  expect_equal(parse_logical(c("t", "f")), c(TRUE, FALSE))
})

test_that("1 and 0 parsed", {
  expect_equal(parse_logical(c("1", "0")), c(TRUE, FALSE))
})

test_that("true and false guessed", {
  expect_equal(guess_parser(c("true", "false")), "logical")
  expect_equal(guess_parser(c("TRUE", "FALSE")), "logical")
  expect_equal(guess_parser(c("T", "F")), "logical")
  expect_equal(guess_parser(c("t", "f")), "logical")

  expect_equal(guess_parser(c("t", "f", "z")), "character")
})

test_that("other values generate warnings", {
    out <- parse_logical(c("A", "AB", "ABCD", "ABCDE", "NA"))
  ## probs <- attr(out, "problems")
  expect_equal(c(out), rep(NA, 5))
  ## expect_equal(n_problems(out), 4)
})
