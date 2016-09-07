#!/usr/bin/Rscript --vanilla

# from https://github.com/ouzor/ouzor.github.com/blob/master/_knitposts.R
# compiles all .Rmd files in _R directory into .md files in _posts directory,
# if the input file is older than the output file.

# run ./knitpages.R to update all knitr files that need to be updated.

KnitPost <- function(input, outfile, base.url="/") {
  # this function is a modified version of an example here:
  # http://jfisher-usgs.github.com/r/2012/07/03/knitr-jekyll/
  require(knitr);
  require(brocks)
  opts_knit$set(base.url = base.url)
  fig.path <- paste0("figures/", sub(".Rmd$", "", basename(input)), "/")
  opts_chunk$set(fig.path = fig.path)
  opts_chunk$set(fig.cap = "testing")
  render_jekyll()
  knit(input, outfile, envir = parent.frame(), encoding = "UTF-8")
}

for (infile in list.files("_source/", pattern = "*.Rmd", full.names = TRUE)) {
  
  outfile = paste0("_posts/", sub(".Rmd$", ".md", basename(infile)))
  
  # knit only if the input file is the last one modified
  if (!file.exists(outfile) |
      file.info(infile)$mtime > file.info(outfile)$mtime) {
    KnitPost(infile, outfile)
    htmlwidgets_deps(infile, always = TRUE)
  }
}
