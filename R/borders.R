#' Border function
#'
#' @param x Origin of the circle
#' @param y Origin of the circle
#' @param r Radius of the circle
#'
#' @return A function that returns a vector of logicals
#' @export
scope_circle <- function(x = .3, y = .5, r = .3) {
  function(scope = scope) {
    (scope$x - x)^2 + (scope$y - y)^2 < r^2
  }
}

#' Border function
#'
#' @param x Origin of the hexagon
#' @param y Origin of the hexagon
#' @param r (Long) radius of the hexagon
#'
#' @return A function that returns a vector of logicals
#' @export
scope_hex <- function(x = .3, y = .5, r = .3) {
  function(scope = scope) {
    inside <- rep(FALSE, nrow(scope))
    dx <- abs(scope$x - x)
    dy <- abs(scope$y - y)
    inside[(dy < r/2) & (dx < (sqrt(3) * r)/2)] <- TRUE
    inside[(dy < r) & (dx / sqrt(3) + dy < r) & (dx < (sqrt(3) * r)/2)] <- TRUE
    return(inside)
  }
}

