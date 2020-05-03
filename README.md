
<!-- README.md is generated from README.Rmd. Please edit that file -->

# scopes

<!-- badges: start -->

[![Travis build
status](https://travis-ci.com/djnavarro/scopes.svg?branch=master)](https://travis-ci.com/djnavarro/scopes)
<!-- badges: end -->

The goal of scopes is to …

## Installation

You can install the released version of scopes from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("scopes")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("djnavarro/scopes")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(scopes)

dat <- scope_grid(
  border = scope_hex(), 
  inner = scope_texture(
    noise = ambient::gen_simplex,
    frequency = 50
  ),
  outer = scope_texture(
    noise = ambient::gen_simplex,
    frequency = 10
  )
)
dat
#> # A tibble: 4,000,000 x 7
#>        x        y inside  outer inner index color    
#>    <dbl>    <dbl> <lgl>   <dbl> <dbl> <dbl> <chr>    
#>  1     0 0        FALSE  -1.25  -1.25     1 #440154FF
#>  2     0 0.000500 FALSE  -1.22  -1.25    21 #450558FF
#>  3     0 0.00100  FALSE  -1.18  -1.25    41 #46085CFF
#>  4     0 0.00150  FALSE  -1.15  -1.25    61 #470C5FFF
#>  5     0 0.00200  FALSE  -1.12  -1.25    80 #471063FF
#>  6     0 0.00250  FALSE  -1.09  -1.25   100 #481466FF
#>  7     0 0.00300  FALSE  -1.05  -1.25   120 #481769FF
#>  8     0 0.00350  FALSE  -1.02  -1.25   139 #481B6DFF
#>  9     0 0.00400  FALSE  -0.991 -1.25   158 #481D6FFF
#> 10     0 0.00450  FALSE  -0.959 -1.25   177 #482072FF
#> # … with 3,999,990 more rows

scope_plot(dat)
```

<img src="man/figures/README-example-1.png" width="100%" />
