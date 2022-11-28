library(parallaxr)

## Character vector of all MD files
all_md_str <- list.files(path = "Parallax/Markdown", full.names = TRUE)


## Loop through each MD file, parse, and return a single tibble
md_tibble <-
  all_md_str %>%
  purrr::map_dfr(parse_md) # Return a tibble with row-binding

## Output HTML file

generate_scroll_doc(path = "Parallax/parallaxr-draft-output.html",
                    inputs = md_tibble)
