test_that("strings mapped to levels", {
  x <- parse_factor(c("a", "b"), levels = c("a", "b"))
  expect_equal(x, factor(c("a", "b")))
})

test_that("can generate ordered factor", {
  x <- parse_factor(c("a", "b"), levels = c("a", "b"), ordered = TRUE)
  expect_equal(x, ordered(c("a", "b")))
})

test_that("warning if value not in levels", {
  x <- parse_factor(c("a", "b", "c"), levels = c("a", "b"))
  ## expect_equal(n_problems(x), 1)
  expect_equal(is.na(x), c(FALSE, FALSE, TRUE))
})

test_that("NAs silently passed along", {
  x <- parse_factor(c("a", "b", "NA"), levels = c("a", "b"), include_na = FALSE)
  ##expect_equal(n_problems(x), 0)
  expect_equal(x, factor(c("a", "b", NA)))
})

test_that("levels = NULL (497)", {
  x <- parse_factor(c("a", "b", "c", "b"), levels = NULL)

  ##expect_equal(n_problems(x), 0)
  expect_equal(x, factor(c("a", "b", "c", "b")))
})

test_that("levels = NULL orders by data", {
  x <- parse_factor(c("b", "a", "c", "b"), levels = NULL)
  expect_equal(levels(x), c("b", "a", "c"))
})

test_that("levels = NULL default (#862)", {
  x <- c("a", "b", "c", "b")
  expect_equal(parse_factor(x), parse_factor(x, levels = NULL))
})

test_that("NAs included in levels if desired", {
  x <- parse_factor(c("NA", "b", "a"), levels = c("a", "b", NA))
  expect_equal(x, factor(c(NA, "b", "a"), levels = c("a", "b", NA), exclude = NULL))

  x <- parse_factor(c("NA", "b", "a"), levels = c("a", "b"), include_na = TRUE)
  expect_equal(x, factor(c(NA, "b", "a"), levels = c("a", "b", NA), exclude = NULL))

  x <- parse_factor(c("NA", "b", "a"), levels = c("a", "b"), include_na = FALSE)
  expect_equal(x, factor(c(NA, "b", "a")))

  x <- parse_factor(c("NA", "b", "a"), levels = NULL, include_na = FALSE)
  expect_equal(x, factor(c(NA, "b", "a"), levels = c("b", "a")))

  x <- parse_factor(c("NA", "b", "a"), levels = NULL, include_na = TRUE)
  expect_equal(x, factor(c(NA, "b", "a"), levels = c(NA, "b", "a"), exclude = NULL))
})

## test_that("Factors handle encodings properly (#615)", {
##   f <- tempfile()
##   on.exit(unlink(f))
##   writeBin(charToRaw(encoded("test\nA\n\xC4\n", "latin1")), f)

##   x <- read_csv(f,
##     col_types = cols(col_factor(c("A", "\uC4"))),
##     locale = locale(encoding = "latin1")
##   )

##   expect_s3_class(x$test, "factor")
##   expect_equal(x$test, factor(c("A", "\uC4")))
## })

test_that("factors parse like factor if trim_ws = FALSE (735)", {
    expect_equal(
      as.integer(parse_factor(c("a", "a "), levels = c("a"), trim_ws = FALSE)),
      as.integer(factor(c("a", "a "), levels = c("a")))
    )

    expect_equal(
        as.integer(parse_factor(c("a", "a "), levels = c("a "), trim_ws = FALSE)),
        as.integer(factor(c("a", "a "), levels = c("a ")))
    )

  expect_equal(
    as.integer(parse_factor(c("a", "a "), levels = c("a", "a "), trim_ws = FALSE)),
    as.integer(factor(c("a", "a "), levels = c("a", "a ")))
  )

  expect_equal(
    as.integer(parse_factor(c("a", "a "), levels = c("a ", "a"), trim_ws = FALSE)),
    as.integer(factor(c("a", "a "), levels = c("a ", "a")))
  )
})

test_that("Can parse a factor with levels of NA and empty string", {
  x <- c(
    "", "NC", "NC", "NC", "", "", "NB", "NA", "", "", "NB", "NA",
    "NA", "NC", "NB", "NB", "NC", "NB", "NA", "NA"
  )

  expect_equal(
    as.integer(parse_factor(x, levels = c("NA", "NB", "NC", ""), na = character())),
    as.integer(factor(x, levels = c("NA", "NB", "NC", "")))
  )
})

test_that("factor levels must be null or a character vector (#1140)", {
  expect_error(col_factor(levels = 1:10), "must be `NULL` or a character vector")
})
