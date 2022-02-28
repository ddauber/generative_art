# GENERATIVE ART WITH LINES #1

#Load packages
library(tidyverse)
library(ggforce)
library(ragg)

# Generate random data

set.seed(12345)

lines <- 500
mean <- 5
sd_x <- 1
sd_y <- 1

df <- tibble(x0 = rnorm(lines,
                       mean = mean,
                       sd = sd_x),
             y0 = rnorm(lines,
                       mean = mean,
                       sd = sd_y),
             start = rnorm(lines,
                           mean = mean,
                           sd = sd_x),
             end = rnorm(lines,
                         mean = mean*1.3,
                         sd = sd_y),
             r = rep(1:lines, 1),
             alpha = rep(runif(lines,
                               min = 0.1,
                               max = 1)),
             size = rep(runif(lines,
                              min = 0.1,
                              max = 1))
             )

# Generate the plot
plot <-
  df %>%
  ggplot() +
  geom_arc(aes(
    x0 = x0,
    y0 = y0,
    start = start,
    end = end,
    r = r,
    alpha = alpha,
    col = r)
  ) +
  theme_void() +
  scale_colour_gradient(low = "#D6F0F8",
                        high = "#001729") +
  theme(
    aspect.ratio = 9/16,
    plot.background = element_rect(fill = "#000000"),
    legend.position = "none",
  )

# Print the plot
ggsave(filename = here::here("2022-02-28", "ga_lines_01.png"),
       plot = plot,
       device = agg_png,
       dpi = 300,
       units = "cm",
       height = 1080/50,
       width = 1920/50)