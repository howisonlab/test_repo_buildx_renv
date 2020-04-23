# syntax = docker/dockerfile:1.0-experimental

FROM rocker/r-base

#ENV RENV_VERSION 0.9.3-80
#RUN --mount=type=cache,target=/buildx_caches/renv_cache R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
#RUN --mount=type=cache,target=/buildx_caches/renv_cache R -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"

#COPY renv_install.R .

COPY hello_world_project /app

RUN --mount=type=cache,target=/buildx_caches/renv_cache Rscript /app/renv_install.R

# copy renv cache from buildx cache mount point
# because buildx cache mount point only available
# this is the sort of thing pip does at the end of building

RUN mkdir -p /root/.local/share/renv
RUN --mount=type=cache,target=/buildx_caches/renv_cache cp -a /buildx_caches/renv_cache/* /root/.local/share/renv
