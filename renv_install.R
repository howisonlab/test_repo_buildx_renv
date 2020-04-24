setwd("/app")
Sys.setenv(RENV_PATHS_ROOT = '/buildx_caches/renv_cache')
install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))
remotes::install_github('rstudio/renv')
