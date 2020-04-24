# syntax = docker/dockerfile:1.0-experimental

FROM rocker/r-base

COPY hello_world_project /app

RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt \
  apt-get update && xargs -a /app/apt.txt apt-get install --yes --no-install-recommends

RUN --mount=type=cache,target=/buildx_caches/renv_cache Rscript /app/renv_install.R

RUN --mount=type=cache,target=/buildx_caches/renv_cache Rscript /app/renv_install_packages.R




# copy renv cache from buildx cache mount point
# because buildx cache mount point only available
# this is the sort of thing pip does at the end of building

# RUN mkdir -p /root/.local/share/renv

# RUN --mount=type=cache,target=/buildx_caches/renv_cache cp -a /buildx_caches/renv_cache/* /root/.local/share/renv
