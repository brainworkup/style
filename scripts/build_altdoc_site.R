#!/usr/bin/env Rscript

# Build a minimal Quarto website for the cingulate package using the config in altdoc/_quarto.yml.
# Outputs to docs/ for GitHub Pages.

required_pkgs <- c("desc")
to_install <- setdiff(required_pkgs, rownames(installed.packages()))
if (length(to_install)) {
  install.packages(to_install, quiet = TRUE)
}

suppressPackageStartupMessages({
  library(desc)
})

root <- normalizePath(".", winslash = "/")
altdoc_dir <- file.path(root, "altdoc")
docs_dir <- file.path(root, "docs")

if (!dir.exists(altdoc_dir)) {
  dir.create(altdoc_dir, recursive = TRUE)
}

# 1) Ensure altdoc/_quarto.yml exists
qf <- file.path(altdoc_dir, "_quarto.yml")
if (!file.exists(qf)) {
  stop("Missing ", qf, ". Please add it first.")
}

# 2) Make an index.md from README.md (fallback to a simple stub)
readme_files <- c(file.path(root, "README.md"), file.path(root, "README.Rmd"))
index_md <- file.path(altdoc_dir, "index.md")

if (file.exists(readme_files[1])) {
  file.copy(readme_files[1], index_md, overwrite = TRUE)
} else if (file.exists(readme_files[2])) {
  # Knit Rmd to md if needed
  if (!requireNamespace("rmarkdown", quietly = TRUE)) {
    install.packages("rmarkdown", quiet = TRUE)
  }
  rmarkdown::render(
    readme_files[2],
    output_format = "md_document",
    output_file = index_md,
    clean = TRUE
  )
} else {
  writeLines(
    c(
      "---",
      "title: \"cingulate\"",
      "---",
      "",
      "Welcome to the cingulate documentation site."
    ),
    index_md
  )
}

# 3) Optionally copy common docs into altdoc/ so sidebar links can point to them
maybe_copy <- function(fn_in, fn_out = fn_in) {
  src <- file.path(root, fn_in)
  dst <- file.path(altdoc_dir, fn_out)
  if (file.exists(src)) file.copy(src, dst, overwrite = TRUE)
}
maybe_copy("LICENSE", "LICENSE.md") # copy & rename to .md for nicer rendering
maybe_copy("CODE_OF_CONDUCT.md")
maybe_copy("NEWS.md")
maybe_copy("CHANGELOG.md")
maybe_copy("CITATION.md")
# If you use CITATION.cff, you can convert/simplify or just link to it:
maybe_copy("CITATION.cff")

# 4) Render with Quarto
render_cmd <- NULL
if (requireNamespace("quarto", quietly = TRUE)) {
  # Use the R helper if present
  quarto::quarto_render(altdoc_dir)
} else {
  # Fallback to system quarto command
  render_cmd <- sprintf('quarto render "%s"', altdoc_dir)
  message("Running: ", render_cmd)
  status <- system(render_cmd)
  if (status != 0) stop("quarto render failed with status ", status)
}

if (dir.exists(docs_dir)) {
  message("Site built successfully to: ", docs_dir)
} else {
  stop(
    "Rendering completed but docs/ was not created. Check altdoc/_quarto.yml output-dir."
  )
}
