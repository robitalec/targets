algorithm_new <- function(
  pipeline = NULL,
  meta = NULL,
  names = NULL,
  shortcut = NULL,
  queue = NULL,
  reporter = NULL,
  seconds_meta = NULL
) {
  algorithm_class$new(
    pipeline = pipeline,
    meta = meta,
    names = names,
    shortcut = shortcut,
    queue = queue,
    reporter = reporter,
    seconds_meta = seconds_meta
  )
}

algorithm_class <- R6::R6Class(
  classname = "tar_algorithm",
  portable = FALSE,
  cloneable = FALSE,
  public = list(
    pipeline = NULL,
    meta = NULL,
    scheduler = NULL,
    names = NULL,
    shortcut = NULL,
    queue = NULL,
    reporter = NULL,
    seconds_meta = NULL,
    seconds_reporter = NULL,
    initialize = function(
      pipeline = NULL,
      meta = NULL,
      names = NULL,
      shortcut = NULL,
      queue = NULL,
      reporter = NULL,
      seconds_meta = NULL,
      seconds_reporter = NULL
    ) {
      self$pipeline <- pipeline
      self$meta <- meta
      self$names <- names
      self$shortcut <- shortcut
      self$queue <- queue
      self$reporter <- reporter
      self$seconds_meta <- seconds_meta
      self$seconds_reporter <- seconds_reporter
    },
    update_scheduler = function() {
      self$scheduler <- scheduler_init(
        pipeline = self$pipeline,
        meta = self$meta,
        queue = self$queue,
        reporter = self$reporter,
        seconds_reporter = self$seconds_reporter,
        names = self$names,
        shortcut = self$shortcut
      )
    },
    bootstrap_shortcut_deps = function() {
      if (!is.null(self$names) && self$shortcut) {
        pipeline_bootstrap_deps(self$pipeline, self$meta, self$names)
      }
    },
    validate = function() {
      pipeline_validate(self$pipeline)
      (self$scheduler %|||% scheduler_init())$validate()
      self$meta$validate()
      tar_assert_chr(self$names %|||% character(0))
      tar_assert_chr(self$queue %|||% character(0))
      tar_assert_chr(self$reporter %|||% character(0))
      tar_assert_dbl(self$seconds_meta)
      tar_assert_scalar(self$seconds_meta)
      tar_assert_none_na(self$seconds_meta)
      tar_assert_dbl(self$seconds_reporter)
      tar_assert_scalar(self$seconds_reporter)
      tar_assert_none_na(self$seconds_reporter)
    }
  )
)
