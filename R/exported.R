library(ambient) # may need dev version: https://github.com/thomasp85/ambient
library(viridis)

# specify the seed and grain
seed <- 272
grain <- 5000

# specify the circle
origin_x <- .3
origin_y <- .5
radius   <- .3

# parameters for the inner & outer textures
inner <- list(
  noise = gen_worley,
  frequency = 3,
  fractal = billow,
  octaves = 20,
  gain = ~. * .9,
  value = "distance"
)
outer <- list(
  noise = gen_worley,
  frequency = 3,
  fractal = billow,
  octaves = 1,
  value = "distance"
)

# paletting function (defaults to viridis::viridis)
color_scheme <- viridis

# filename
fname <- paste0("~/Desktop/scope_05_", seed, ".png")


# generate the grid -------------------------------------------------------

# reset the RNG state
set.seed(seed)

# create a grid with coordinates
grid <- long_grid(
  x = seq(from = 0, to = 1,length.out = grain),
  y = seq(from = 0, to = 1,length.out = grain)
)

# inside=TRUE for points inside the circle
grid$inside <- (grid$x - origin_x)^2 + (grid$y - origin_y)^2 < radius^2



# define textures ---------------------------------------------------------

# convenience functions
fracture_outer <- function(...) {
  fracture(
    x = grid$x * (1 - grid$inside),
    y = grid$y * (1 - grid$inside),
    seed = seed,
    ...
  )
}
fracture_inner <- function(...) {
  fracture(
    x = grid$x * grid$inside,
    y = grid$y * grid$inside,
    seed = seed,
    ...
  )
}

# generate textures
grid$outer <- do.call(fracture_outer, outer)
grid$inner <- do.call(fracture_inner, inner)


# add colors --------------------------------------------------------------

# palette index
grid$index <- round(1 + (grain - 1) * normalise(grid$inner + grid$outer))

# colors
cols <- color_scheme(n = grain)
grid$color <- cols[grid$index]


# create and print raster -------------------------------------------------

rast <- as.raster(grid, value = color)
png(filename = fname, width = grain, height = grain)
op <- par(mar = c(0,0,0,0))
plot(rast)
dev.off()
par(op)

