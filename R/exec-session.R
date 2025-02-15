#' @title Return the [sessionInfo()]
#'   of the last call to [make()].
#' @description By default, session info is saved
#' during [make()] to ensure reproducibility.
#' Your loaded packages and their versions are recorded, for example.
#' @seealso [diagnose()], [cached()],
#'   [readd()], [drake_plan()], [make()]
#' @export
#' @return [sessionInfo()] of the last
#'   call to [make()]
#' @inheritParams cached
#' @examples
#' \dontrun{
#' isolate_example("Quarantine side effects.", {
#' if (suppressWarnings(require("knitr"))) {
#' load_mtcars_example() # Get the code with drake_example("mtcars").
#' make(my_plan) # Run the project, build the targets.
#' drake_get_session_info() # Get the cached sessionInfo() of the last make().
#' }
#' })
#' }
drake_get_session_info <- function(
  path = NULL,
  search = NULL,
  cache = drake::drake_cache(path = path, verbose = verbose),
  verbose = 1L
) {
  if (is.null(cache)) {
    stop("No drake::make() session detected.")
  }
  return(cache$get("sessionInfo", namespace = "session"))
}

drake_set_session_info <- function(
  path = NULL,
  search = NULL,
  cache = drake::drake_cache(path = path, verbose = verbose),
  verbose = 1L,
  full = TRUE
) {
  if (is.null(cache)) {
    stop("No drake::make() session detected.")
  }
  if (full) {
    cache$set(
      key = "sessionInfo",
      value = utils::sessionInfo(),
      namespace = "session"
    )
  }
  cache$set(
    key = "drake_version",
    value = as.character(utils::packageVersion("drake")),
    namespace = "session"
  )
  invisible()
}

initialize_session <- function(config) {
  runtime_checks(config = config)
  config$cache$set(key = "seed", value = config$seed, namespace = "session")
  init_common_values(config$cache)
  config$eval[[drake_envir_marker]] <- TRUE
  if (config$log_progress) {
    clear_tmp_namespace(
      cache = config$cache,
      jobs = config$jobs_preprocess,
      namespace = "progress"
    )
  }
  drake_set_session_info(cache = config$cache, full = config$session_info)
  do_prework(config = config, verbose_packages = config$verbose)
  invisible()
}

conclude_session <- function(config) {
  drake_cache_log_file_(
    file = config$cache_log_file,
    cache = config$cache,
    jobs = config$jobs_preprocess
  )
  remove(list = names(config$eval), envir = config$eval)
  config$cache$flush_cache()
  if (config$garbage_collection) {
    gc()
  }
  invisible()
}

prompt_intv_make <- function(config) {
  menu_enabled <- .pkg_envir[["drake_make_menu"]] %||%
    getOption("drake_make_menu") %||%
    TRUE
  interactive() &&
    igraph::gorder(config$graph) &&
    menu_enabled
}

abort_intv_make <- function(config) {
  # nocov start
  on.exit(
    assign(
      x = "drake_make_menu",
      value = FALSE,
      envir = .pkg_envir,
      inherits = FALSE
    )
  )
  title <- paste(
    paste(igraph::gorder(config$graph), "outdated targets:"),
    multiline_message(igraph::V(config$graph)$name),
    "\nPlease read the \"Interactive mode\" section of the make() help file.",
    "This prompt only appears once per session.",
    "\nReally run make() instead of r_make() in interactive mode?",
    sep = "\n"
  )
  out <- utils::menu(choices = c("yes", "no"), title = title)
  !identical(as.integer(out), 1L)
  # nocov end
}
