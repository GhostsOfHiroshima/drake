---
name: Bug
about: Something is wrong with drake.
title: ''
labels: 'type: bug'
assignees: wlandau
---

## Prework

- [ ] Read and abide by `drake`'s [code of conduct](https://github.com/ropensci/drake/blob/master/CODE_OF_CONDUCT.md).
- [ ] Search for duplicates among the [existing issues](https://github.com/ropensci/drake/issues), both open and closed.
- [ ] I am reasonably sure this is a genuine bug in `drake` and most likely not a user error. (If you run into an error and do not know the cause, please submit a "Trouble" issue instead.)
- [ ] Advanced users: verify that the bug still persists in the current development version (i.e. `remotes::install_github("ropensci/drake")`) and mention the [SHA-1 hash](https://git-scm.com/book/en/v1/Getting-Started-Git-Basics#Git-Has-Integrity) of the [Git commit you install](https://github.com/ropensci/drake/commits/master).

## Description

Describe the bug clearly and concisely. 

## Reproducible example

Provide a minimal reproducible example with code and output that demonstrates the problem. The `reprex()` function from the [`reprex`](https://github.com/tidyverse/reprex) package is extremely helpful for this.

To help us read your code, please try to follow the [tidyverse style guide](https://style.tidyverse.org/). The `style_text()` and `style_file()` functions from the [`styler`](https://github.com/r-lib/styler) package make it easier.

## Expected result

What should have happened? Please be as specific as possible.

## Session info

End the reproducible example with a call to `sessionInfo()` in the same session (e.g. `reprex(si = TRUE)`) and include the output.
