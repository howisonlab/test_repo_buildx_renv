# syntax = docker/dockerfile:1.0-experimental

FROM rocker/r-base

ENV RENV_VERSION 0.9.3-80
RUN --mount=type=cache,target=/buildx_caches/renv_cache R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN --mount=type=cache,target=/buildx_caches/renv_cache R -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"

# COPY install.R .

# RUN --mount=type=cache,target=/buildx_caches/renv_cache R -e install.R 

RUN --mount=type=cache,target=/buildx_caches/renv_cache R -e "Sys.setenv(RENV_PATHS_ROOT = '/buildx_caches/renv_cache'); renv::consent(TRUE); renv:::renv_paths_cache(); renv::init(); renv::status(); renv::shapshot()"
 
# RUN --mount=type=cache,target=/buildx_caches/renv_cache tar xvf - -C /cache
