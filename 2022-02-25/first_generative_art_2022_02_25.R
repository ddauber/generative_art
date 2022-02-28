library(tidyverse)
library(jasmines)
library(ragg)

plot <-
  use_seed(1) %>%
  scene_discs(rings = 1, points = 5000, size = 5) %>%
  unfold_warp(iterations = 1,
              scale = 0.5,
              output = "layer"
  ) %>%
  unfold_tempest(
    iterations = 20,
    scale = 0.01) %>%

  style_ribbon(
    palette = palette_manual(c("#303030")),
    background = "#F5E367",
    alpha = c(0.1, 0.1)
  )

ggsave(filename = here::here("2022-02-25", "first_generative_art.png"),
       plot = plot,
       device = agg_png,
       dpi = 600,
       units = "cm",
       height = 1080/50,
       width = 1920/50)
