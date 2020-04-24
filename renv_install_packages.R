setwd("/app")
Sys.setenv(RENV_PATHS_ROOT = '/buildx_caches/renv_cache')
options(renv.config.auto.snapshot = TRUE) # avoids the lockfile is out of synch problem
renv::consent(TRUE)
renv::init() # gets shims, so install.R can call install.packages instead of renv::install

source("install.R") # runs install.packages commands

# copy packages from cache to project directory
renv::isolate()
