# Generative Art: Lines #2

# LOAD PACKAGES -----------------------------------------------------------
library(tidyverse)
library(ambient)
library(ragg)


# SET PARAMETERS ----------------------------------------------------------
params <- list(
  seed = 2,
  lines = 2000,
  steps = 80,
  length = 100,
  slip = 40,
  min = 0.25,
  max = 5
)

set.seed(seed = params$seed)

# CREATE DATASET ----------------------------------------------------------
df <- tibble(
  x = runif(n = params$lines, min = params$min, max = params$max),
  y = runif(n = params$lines, min = params$min, max = params$max),
  z = 0,
  color = 0
)

df <-
  df %>%
  mutate(path_id = 1:params$lines, .before = everything(),
         step_id = 1)

df_art <- df

# Generate data in the loop

stop_painting <- FALSE

while(stop_painting == FALSE) {

  # Create noise and use for settings steps
  step <- curl_noise(
    generator = gen_spheres,
    x = df$x,
    y = df$y,
    z = df$z,
    seed = c(1, 1, 1) * params$seed
  )

  df <- df %>%
    mutate(
      x = x + (step$x / 10000) * params$length,
      y = y + (step$y / 10000) * params$length,
      z = z + (step$z / 10000) * params$slip,
      step_id = step_id + 1,
      color = color + step$z
    )

  # append new data
  df_art <- rbind(df_art, df)

  # check whether looping should stop
  if(last(df$step_id) >= params$steps) {
    stop_painting <- TRUE
  }

}

# CREATE PLOT -------------------------------------------------------------

plot <-
  df_art %>%
  ggplot(aes(x = x,
             y = y,
             group = path_id,
             color = step_id)
         ) +
  geom_path(
    size = 0.5,
    alpha = 0.25,
    show.legend = FALSE
  ) +
  coord_equal() +
  theme_void() +
  scale_color_gradient(low = "#0077B6",
                       high = "#CAF0F8") +
  theme(
    plot.background = element_rect(fill = "#000000")
  )

plot

# SAVE PLOT ---------------------------------------------------------------

filename <- params %>%
  str_c(collapse = "-") %>%
  str_c("ga_lines_02_", ., ".png", collapse = "")

ggsave(filename = here::here("2022-03-01", "00_render", filename),
       plot = plot,
       device = agg_png,
       dpi = 300,
       height = 3000/300,
       width = 3000/300
       )

