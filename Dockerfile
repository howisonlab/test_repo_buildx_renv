# syntax = docker/dockerfile:1.0-experimental

FROM rocker/verse

ENV RENV_VERSION 0.9.3-80
RUN --mount=type=cache,target=/buildx_caches/renv_cache R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN --mount=type=cache,target=/buildx_caches/renv_cache R -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"

RUN --mount=type=cache,target=/buildx_caches/renv_cache tar xvf mycache.tar -C /buildx_caches
