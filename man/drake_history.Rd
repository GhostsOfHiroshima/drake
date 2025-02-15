% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/api-history.R
\name{drake_history}
\alias{drake_history}
\title{History and provenance}
\usage{
drake_history(cache = NULL, history = NULL, analyze = TRUE,
  verbose = TRUE)
}
\arguments{
\item{cache}{drake cache as created by \code{\link[=new_cache]{new_cache()}}.
See also \code{\link[=drake_cache]{drake_cache()}}.}

\item{history}{Logical, whether to record the build history
of your targets. You can also supply a
\href{https://github.com/wlandau/txtq}{txtq}, which is
how \code{drake} records history.
Must be \code{TRUE} for \code{\link[=drake_history]{drake_history()}} to work later.}

\item{analyze}{Logical, whether to analyze \code{\link[=drake_plan]{drake_plan()}}
commands for arguments to function calls.
Could be slow because this requires parsing and analyzing
lots of R code.}

\item{verbose}{Integer, control printing to the console/terminal.
\itemize{
\item \code{0}: print nothing.
\item \code{1}: print targets, retries, and failures.
\item \code{2}: also show a spinner when preprocessing tasks are underway.
}}
}
\value{
A data frame of target history.
}
\description{
See the history and provenance of your targets:
what you ran, when you ran it, the function arguments
you used, and how to get old data back.
}
\details{
If \code{analyze} is \code{TRUE}, \code{drake}
scans your \code{\link[=drake_plan]{drake_plan()}} commands
for function arguments and mentions them in the history.
A function argument shows up if and only if
1. It has length 1.
2. It is atomic, i.e. a base type: logical, integer,
real, complex, character, or raw.
3. It is explicitly named in the function call,
For example, \code{x} is detected as \code{1} in
\code{fn(list(x = 1))} but not \code{f(list(1))}.
The exceptions are \code{\link[=file_out]{file_out()}}, \code{\link[=file_in]{file_in()}},
and \code{\link[=knitr_in]{knitr_in()}}. For example, \code{filename} is detected
as \code{"my_file.csv"} in
\code{process_data(filename = file_in("my_file.csv"))}.
NB: in \code{process_data(filename = file_in("a", "b"))}
\code{filename} is not detected because the value must be atomic.
}
\examples{
\dontrun{
isolate_example({
# First, let's iterate on a drake workflow.
load_mtcars_example()
make(my_plan, history = TRUE, verbose = 0L)
# Naturally, we'll make updates to our targets along the way.
reg2 <- function(d) {
  d$x2 <- d$x ^ 3
  lm(y ~ x2, data = d)
}
Sys.sleep(0.01)
make(my_plan, history = TRUE, verbose = 0L)
# The history is a data frame about all the recorded runs of your targets.
out <- drake_history(analyze = TRUE)
print(out)
# Let's use the history to recover the oldest version
# of our regression2_small target.
oldest_reg2_smsall <- max(which(out$target == "regression2_small"))
hash_oldest_reg2_small <- out[oldest_reg2_small, ]$hash
cache <- drake_cache()
cache$get_value(hash_oldest_reg2_small)
# If you run clean(), drake can still find all the targets.
clean(small)
drake_history()
# But if you run clean() with garbage collection,
# older versions of your targets may be gone.
clean(large, garbage_collection = TRUE)
drake_history()
})
}
}
