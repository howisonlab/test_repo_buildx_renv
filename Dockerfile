# syntax = docker/dockerfile:1.0-experimental

FROM rocker/r-base

COPY hello_world_project/renv_install.R /app/renv_install.R
RUN --mount=type=cache,target=/buildx_caches/renv_cache Rscript /app/renv_install.R

COPY hello_world_project/apt.txt /app/apt.txt
RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt \
  apt-get update && xargs -a /app/apt.txt apt-get install --yes --no-install-recommends

COPY hello_world_project/renv_install_packages.R /app/renv_install_packages.R
COPY hello_world_project/install.R /app/install.R
RUN --mount=type=cache,target=/buildx_caches/renv_cache Rscript /app/renv_install_packages.R

COPY hello_world_project /app
