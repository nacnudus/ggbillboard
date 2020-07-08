#' Add images to vacant facets in ggplots
#'
#' When there are more facets than categories of data, fill the vacant facets
#' with images.
#'
#' @param plot A ggplot object
#' @param images A single image grob or a list of image grobs (see examples).
#'
#' @examples
#' if (all(c(require("png"), require("jpeg")))) {
#'   library(ggplot2)
#'
#'   img1 <- readPNG(system.file("img", "Rlogo.png", package="ggbillboard"))
#'   img2 <- readJPEG(system.file("img", "spongebob.png", package="ggbillboard"))
#'   g1 <- grid::rasterGrob(img1, interpolate=TRUE)
#'   g2 <- grid::rasterGrob(img2, interpolate=TRUE)
#'
#'   p1 <-
#'     ggplot(economics_long, aes(date, value)) +
#'     geom_line() +
#'     facet_wrap(vars(variable), scales = "free_y", nrow = 2)
#'
#'   billboard(p1, g1)
#'   billboard(p1, list(g1))
#'
#'   p2 <-
#'     ggplot(ChickWeight, aes(Time, weight)) +
#'     geom_point() +
#'     facet_wrap(~ Diet, ncol = 3)
#'
#'   billboard(p2, list(g1, g2))
#'   billboard(p2, list(g2, g1))
#' }
#' @export
billboard <- function(plot, images) {
  grob <- ggplot2::ggplotGrob(plot)
  matches <- which(is_panel(grob) & is_zeroGrob(grob))
  images <- rlang::squash(list(images))
  images <- rep_len(images, length(matches))
  i <- 0
  for (match in matches) {
    i <- i + 1
    grob$grobs[[match]] <- images[[i]]
  }
  ggplotify::as.ggplot(grob)
}

is_panel <- function(x) {
  grepl("panel-", x$layout$name)
}

is_zeroGrob <- function(x) {
  vapply(x$grobs, identical, logical(1), ggplot2::zeroGrob())
}
