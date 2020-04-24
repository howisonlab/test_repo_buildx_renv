# syntax = docker/dockerfile:1.0-experimental

FROM rocker/r-base

COPY renv_install.R /app/renv_install.R
RUN Rscript /app/renv_install.R

COPY renv_install_packages.R /app/renv_install_packages.R
COPY install.R /app/install.R
RUN --mount=type=cache,target=/buildx_caches/renv_cache Rscript /app/renv_install_packages.R

# COPY hello_world_project/hello_world.R /app
