

#' Parameters for the fractal texture
#'
#' @param noise Function generating the multidimensional noise
#' @param frequency Frequency
#' @param fractal Fractal function
#' @param octaves How many octaves
#' @param ... Other arguments
#'
#' @return A list
#' @export
scope_texture <- function(
  noise = ambient::gen_worley,
  frequency = 1,
  fractal = ambient::billow,
  octaves = 3,
  ...
) {
  list(
    noise = noise,
    frequency = frequency,
    fractal = fractal,
    octaves = octaves,
    ...
  )
}


#' Construct the data for a scopes plot
#'
#' @param seed Random number generator seed
#' @param grain Number of pixels
#' @param border Function specifying the border
#' @param inner List of texture parameters for inner region
#' @param outer List of texture parameters for outer region
#' @param palette Palette generating function
#'
#' @return A tibble
#' @export
scope_grid <- function(seed = 272, grain = 2000, border = scope_circle(),
                        inner = scope_texture(frequency = 5),
                        outer = scope_texture(frequency = 2),
                        palette = viridis::viridis) {

  # create a scope with coordinates
  scope <- ambient::long_grid(
    x = seq(from = 0, to = 1,length.out = grain),
    y = seq(from = 0, to = 1,length.out = grain)
  )

  # inside=TRUE for points inside the circle
  scope$inside <- border(scope)

  # reset the RNG state
  set.seed(seed)

  # convenience functions
  fracture_outer <- function(...) {
    ambient::fracture(
      x = scope$x * (1 - scope$inside),
      y = scope$y * (1 - scope$inside),
      seed = seed,
      ...
    )
  }
  fracture_inner <- function(...) {
    ambient::fracture(
      x = scope$x * scope$inside,
      y = scope$y * scope$inside,
      seed = seed,
      ...
    )
  }

  # generate textures
  scope$outer <- do.call(fracture_outer, outer)
  scope$inner <- do.call(fracture_inner, inner)

  # palette index
  scope$index <- round(1 + (grain - 1) * ambient::normalise(scope$inner + scope$outer))

  # colors
  cols <- palette(n = grain)
  scope$color <- cols[scope$index]

  return(scope)
}


#' Write scopes data to a png
#'
#' @param scope The scope data
#' @param filename Path to file (if default, use current graphics device)
#' @param grain Image width & height
#'
#' @export
scope_plot <- function(scope, filename = NULL, grain = 2000) {
  rast <- grDevices::as.raster(scope, value = color)
  if(!is.null(filename)) grDevices::png(filename = filename, width = grain, height = grain)
  op <- graphics::par(mar = c(0,0,0,0))
  graphics::plot(rast)
  if(!is.null(filename)) grDevices::dev.off()
  graphics::par(op)
}

utils::globalVariables("color")


