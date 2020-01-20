#! /usr/bin/env Rscript
#bookdown::render_book("index.Rmd", "bookdown::gitbook")
#bookdown::render_book("index.Rmd", bookdown::html_document2(toc=T, toc_depth=3))
bookdown::render_book("index.Rmd", rmarkdown::word_document(toc=T, toc_depth=3))
bookdown::render_book("index.Rmd", rmarkdown::pdf_document(toc=T, toc_depth=3, latex_engine="xelatex"))
