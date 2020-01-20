library(DiagrammeR)
library(DiagrammeRsvg)
library(magrittr)
library(rsvg)

grVizPng <- function(graph, width=400, height=200, caption=""){
  hs = digest::digest(graph)
  fn = paste0("media/gv/", hs)
  fnpng = paste0(fn, ".png")
  fnpdf = paste0(fn, ".pdf")
  x = grViz(graph, width=width, height=height)
  x %>% export_svg %>% charToRaw %>% rsvg_png(fnpng)
  x %>% export_svg %>% charToRaw %>% rsvg_pdf(fnpdf)
  return(fnpdf)
}
#
# grVizPng('
# digraph mary {
#     {node [shape=box];}
#     "Choice of footwear"
#     "Exam grade"
#   }
# ')
